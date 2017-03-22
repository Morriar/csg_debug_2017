On Wed, Jul 23, 2014 at 6:43 PM, Michel DÃnzer <michel@xxxxxxxxxxx> wrote:
>>
>> Michel, mind doing
>>
>> make kernel/sched/fair.s
>>
>> and sending us the resulting file?
>
> Here it is, gzipped, hope that's okay.
>
> Note that my tree is now based on 3.16-rc6.

Ok, so I'm looking at the code generation and your compiler is pure
and utter *shit*.

Adding Jakub to the cc, because gcc-4.9.0 seems to be terminally broken.

Lookie here, your compiler does some absolutely insane things with the
spilling, including spilling a *constant*. For chrissake, that
compiler shouldn't have been allowed to graduate from kindergarten.
We're talking "sloth that was dropped on the head as a baby" level
retardation levels here:

...
movq $load_balance_mask, -136(%rbp) #, %sfp
subq $184, %rsp #,
movq (%rdx), %rax # sd_22(D)->parent, sd_parent
movl %edi, -144(%rbp) # this_cpu, %sfp
movl %ecx, -140(%rbp) # idle, %sfp
movq %r8, -200(%rbp) # continue_balancing, %sfp
movq %rax, -184(%rbp) # sd_parent, %sfp
movq -136(%rbp), %rax # %sfp, tcp_ptr__
#APP
add %gs:this_cpu_off, %rax # this_cpu_off, tcp_ptr__
#NO_APP
...

Note the contents of -136(%rbp). Seriously. That's an
_immediate_constant_ that the compiler is spilling.

Somebody needs to raise that as a gcc bug. Because it damn well is
some seriously crazy shit.

However, that constant spilling part just counts as "too stupid to
live". The real bug is this:

movq $load_balance_mask, -136(%rbp) #, %sfp
subq $184, %rsp #,

where gcc creates the stack frame *after* having already used it to
save that constant *deep* below the stack frame.

The x86-64 ABI specifies a 128-byte red-zone under the stack pointer,
and this is ok by that limit. It looks like it's illegal (136 > 128),
but the fact is, we've had four "pushq"s to update %rsp since loading
the frame pointer, so it's just *barely* legal with the red-zoning.

But we build the kernel with -mno-red-zone. We do *not* follow the
x86-64 ABI wrt redzoning, because we *cannot*: interrupts while in
kernel mode *will* use the stack without a redzone. So that
"-mno-red-zone" is not some "optional guideline". It's a hard and
harsh requirement for the kernel, and gcc-4.9 is a buggy piece of shit
for ignoring it. And your bug happens becuase you happen to hit an
interrupt _just_ in that single instruction window (or perhaps hit
some other similar case and corrupted kernel data structures earlier).

Now, I suspect that this redzoning bug might actually be related to
the fact that gcc is stupid in spilling a constant. I would not be
surprised if there is some liveness analysis going on to decide *when*
to insert the stack decrement, and constants are being ignored because
clearly liveness isn't an issue for a constant value. So the two bugs
("stupid constant spilling" and "invalid use or red zone stack") go
hand in hand. But who knows.

Anyway, this is not a kernel bug. This is your compiler creating
completely broken code. We may need to add a warning to make sure
nobody compiles with gcc-4.9.0, and the Debian people should probably
downgrate their shiny new compiler.

Jakub, any ideas?

Linus
