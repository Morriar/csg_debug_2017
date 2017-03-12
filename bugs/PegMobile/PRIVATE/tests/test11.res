<?xml version="1.0" encoding="UTF-8"?>
<project>
	<description>Builds, tests, and runs the project contrats_exemples.</description>
	<import file="nbproject/build-impl.xml">
		<target name="-post-compile">
			<obfuscate>
				<fileset>build.classes.dir</fileset>
			</obfuscate>
		</target>
		<target name="run" depends="ex-impl.jar">
			<exec dir="bin" executable="launcher.exe">
				<arg>dist.jar</arg>
			</exec>
		</target>
	</import>
</project>
