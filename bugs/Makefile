# Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

help:
	@echo "usage:"
	@echo " * check		check all bugs"

check:
	@make --no-print-directory -C bug_hello/ check
	@make --no-print-directory -C FireMatches/ check

clean:
	@make --no-print-directory -C bug_hello/ clean
	@make --no-print-directory -C FireMatches/ clean
