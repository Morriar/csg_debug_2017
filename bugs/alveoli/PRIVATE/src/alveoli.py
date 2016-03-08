#!/usr/bin/python3
#
# Addition of an import hook to make it possible to
# import XML-structure specifications directly

import imp
import os
import re
import sys

from collections import OrderedDict
from inspect import Parameter, Signature
from xml.etree.ElementTree import parse

def _make_init(fields):
    '''
    Give a list of field names, make an __init__ method
    '''
    code = 'def __init__(self, %s):\n' % \
        ', '.join(fields)

    for name in fields:
        code += '    self.%s = %s\n' % (name, name)
    return code

def _make_setter(dcls):
    code = 'def __set__(self, instance, value):\n'
    for d in dcls.__mro__:
        if 'set_code' in d.__dict__:
            for line in d.set_code():
                code += '    ' + line + '\n'
    return code

class DescriptorMeta(type):
    def __init__(self, clsname, bases, clsdict):
        if '__set__' not in clsdict:
            code = _make_setter(self)
            exec(code, globals(), clsdict)
            setattr(self, '__set__', clsdict['__set__'])
        # TODO Remove this
        else:
            raise TypeError('Define set_code(), not __set__()')

class D(metaclass=DescriptorMeta):
    def __init__(self, name=None):
        self.name = name

    @staticmethod
    def set_code():
        return [
            'instance.__dict__[self.name] = value'
            ]

class T(D):
    _type = object
    @staticmethod
    def set_code():
        return [
            'if not isinstance(value, self._type):',
            '    print("NOP")',
            '    sys.exit(0)',
            ]

class I(T):
    _type = int

class F(T):
    _type = float

class S(T):
    _type = str

class P(D):
    @staticmethod
    def set_code():
        return [
            'if value < 0:',
            '    print("NOP")',
            '    sys.exit(0)',
            ]
        super().__set__(instance, value)

class O(I):
    @staticmethod
    def set_code():
        return [
                'if value % 2 == 0:',
                '    print("NOP")',
                '    sys.exit(0)',
                ]
        super().__set__(instance, value)

class PI(I, P):
    pass

class PF(F, P):
    pass

class L(D):
    def __init__(self, *args, ml, **kwargs):
        self.ml = ml
        super().__init__(*args, **kwargs)

    @staticmethod
    def set_code():
        return [
            'if len(value) > self.ml:',
            '    print("NOP")',
            '    sys.exit(0)',
            ]

class SS(S, L):
    pass

class RS(D):
    def __init__(self, *args, pat, **kwargs):
        self.pat = re.compile(pat)
        super().__init__(*args, **kwargs)

    @staticmethod
    def set_code():
        return [
            'if not self.pat.match(value):',
            '    print("NOP")',
            '    sys.exit(0)',
            ]

class SSRS(SS, RS):
    pass

# Structure definition code

class StructMeta(type):
    @classmethod
    def __prepare__(cls, name, bases):
        return OrderedDict()

    def __new__(cls, clsname, bases, clsdict):
        fields = [key for key, val in clsdict.items()
                  if isinstance(val, D) ]
        for name in fields:
            clsdict[name].name = name

        if fields:
            exec(_make_init(fields), globals(), clsdict)

        clsobj = super().__new__(cls, clsname, bases, dict(clsdict))
        setattr(clsobj, '_fields', fields)
        return clsobj

class Structure(metaclass=StructMeta):
    pass

def _xml_to_code(filename):
    doc = parse(filename)
    code = 'import alveoli as _i\n'
    for al in doc.findall('alveolus'):
        code += _xml_struct_code(al)
    return code

def _xml_struct_code(st):
    stname = st.get('name')
    code = 'class %s(_i.Structure):\n' % stname
    for field in st.findall('field'):
        name = field.text.strip()
        dtype = '_i.' + field.get('type')
        kwargs = ', '.join('%s=%s' % (key, val)
                           for key, val in field.items()
                           if key != 'type')
        code += '    %s = %s(%s)\n' % (name, dtype, kwargs)
    return code

class StructImporter:
    def __init__(self, path):
        self._path = path

    def find_module(self, fullname, path=None):
        name = fullname.rpartition('.')[-1]
        if path is None:
            path = self._path
        for dn in path:
            filename = os.path.join(dn, name+'.xml')
            if os.path.exists(filename):
                return EnterpriseLoader(filename)
        return None

class EnterpriseLoader:
    def __init__(self, filename):
        self._filename = filename

    def load_module(self, fullname):
        mod = sys.modules.setdefault(fullname,
                                     imp.new_module(fullname))
        mod.__file__ = self._filename
        mod.__loader__ = self
        code = _xml_to_code(self._filename)
        exec(code, mod.__dict__, mod.__dict__)
        return mod

def install_importer(path=sys.path):
    sys.meta_path.append(StructImporter(path))

install_importer()
import alveoli_defs
