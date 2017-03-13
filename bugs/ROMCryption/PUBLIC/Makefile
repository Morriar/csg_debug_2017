#                 UQAM ON STRIKE PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2017
# Alexandre Terrasa <@>,
# Philippe Pepos Petitclerc <@>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#                 UQAM ON STRIKE PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just do what the fuck you want to as long as you're on strike.
#
# aHR0cDovL2NzZ2FtZXMub3JnLzIwMTYvCg==#
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

compile:
	mkdir -p bin/
	cp src/trap src/pep8os.pepo bin/
	cd bin/ && asem8 ../src/romcryption.pep
	mv src/romcryption.pepo bin/

check:
	./tests.sh

clean:
	rm -rf bin/ out/
