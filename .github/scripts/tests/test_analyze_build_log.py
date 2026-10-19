#!/usr/bin/env python3

import importlib.util
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / "analyze-build-log.py"
SPEC = importlib.util.spec_from_file_location("analyze_build_log", SCRIPT)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class AnalyzerProbeTests(unittest.TestCase):
    def classify(self, text: str):
        lines = [MODULE.clean(line) for line in text.strip().splitlines()]
        return MODULE.classify(lines)

    def test_iffe_negative_probe_errors_are_excluded(self):
        result = self.classify(
            r"""
+ iffe -d1 -v run features/lib
./12345.c:1:2: error: expected identifier before ';'
iffe: test: is -liconv a library ...
/usr/bin/ld: cannot find -liconv: No such file or directory
collect2: error: ld returned 1 exit status
iffe: ... no
./12345.c:29:2: error: #error not BSD
/usr/src/arch/./12345.c:33:(.text+0x7): undefined reference to `FoobaR'
collect2: error: ld returned 1 exit status
real.c:9: warning: ordinary warning
"""
        )
        compiler, linker, make, warnings, probes = result
        self.assertEqual(compiler, [])
        self.assertEqual(linker, [])
        self.assertEqual(make, [])
        self.assertEqual(warnings, [9])
        self.assertEqual(probes, [1, 3, 4, 6, 7, 8])

    def test_real_error_after_iffe_test_is_preserved(self):
        result = self.classify(
            r"""
iffe: test: some capability ...
./77777.c:4:2: error: #error expected probe miss
iffe: ... no
real.c:42:7: error: incompatible types
make[3]: *** [Makefile:99: real.o] Error 1
"""
        )
        compiler, linker, make, warnings, probes = result
        self.assertEqual(compiler, [3])
        self.assertEqual(linker, [])
        self.assertEqual(make, [4])
        self.assertEqual(warnings, [])
        self.assertEqual(probes, [1])

    def test_real_error_before_iffe_is_preserved(self):
        result = self.classify(
            r"""
real.c:5:3: error: use of undeclared identifier
+ iffe -d1 -v run features/lib
./88888.c:7:2: error: #error expected probe miss
iffe: ... no
"""
        )
        compiler, linker, make, warnings, probes = result
        self.assertEqual(compiler, [0])
        self.assertEqual(linker, [])
        self.assertEqual(make, [])
        self.assertEqual(warnings, [])
        self.assertEqual(probes, [2])

    def test_generated_looking_source_outside_iffe_is_not_hidden(self):
        result = self.classify(
            r"""
./x12345.c:8:2: error: real source failure
make[2]: *** [Makefile:66: x12345.o] Error 1
"""
        )
        compiler, linker, make, warnings, probes = result
        self.assertEqual(compiler, [0])
        self.assertEqual(linker, [])
        self.assertEqual(make, [1])
        self.assertEqual(warnings, [])
        self.assertEqual(probes, [])

    def test_implicit_iffe_activity_keeps_hex_temp_probe_excluded(self):
        result = self.classify(
            r"""
+ iffe -d1 -v run features/lib
+ echo generated configuration
+ echo more internal shell trace
./2f8f69246.c:1:2: error: expected identifier before ';'
iffe: test: is sys/types.h a header ...
iffe: ... yes
"""
        )
        compiler, linker, make, warnings, probes = result
        self.assertEqual(compiler, [])
        self.assertEqual(linker, [])
        self.assertEqual(make, [])
        self.assertEqual(warnings, [])
        self.assertEqual(probes, [3])

    def test_next_shell_command_blocks_future_iffe_context(self):
        result = self.classify(
            r"""
+ iffe -d1 -v run features/lib
./99999.c:7:2: error: #error expected probe miss
iffe: ... no
+ cc -c ./x12345.c
./x12345.c:9:2: error: real source failure
+ iffe -d1 -v run features/other
iffe: test: some later capability ...
iffe: ... yes
"""
        )
        compiler, linker, make, warnings, probes = result
        self.assertEqual(compiler, [4])
        self.assertEqual(linker, [])
        self.assertEqual(make, [])
        self.assertEqual(warnings, [])
        self.assertEqual(probes, [1])

    def test_real_linker_error_after_probe_is_preserved(self):
        result = self.classify(
            r"""
iffe: test: is -lmissing a library ...
/usr/bin/ld: cannot find -lmissing: No such file or directory
collect2: error: ld returned 1 exit status
iffe: ... no
/usr/bin/ld: cannot find -lreal: No such file or directory
collect2: error: ld returned 1 exit status
make[2]: *** [Makefile:88: app] Error 1
"""
        )
        compiler, linker, make, warnings, probes = result
        self.assertEqual(compiler, [])
        self.assertEqual(linker, [4, 5])
        self.assertEqual(make, [6])
        self.assertEqual(warnings, [])
        self.assertEqual(probes, [1, 2])

    def test_iffe_own_error_is_not_hidden_without_probe_evidence(self):
        result = self.classify(
            r"""
+ iffe -d1 -v run features/lib
iffe: test: malformed capability ...
iffe: internal fatal error: malformed feature file
iffe: ... no
make[2]: *** [Makefile:77: FEATURE/foo] Error 1
"""
        )
        compiler, linker, make, warnings, probes = result
        self.assertEqual(compiler, [])
        self.assertEqual(linker, [2])
        self.assertEqual(make, [4])
        self.assertEqual(warnings, [])
        self.assertEqual(probes, [])


if __name__ == "__main__":
    unittest.main()
