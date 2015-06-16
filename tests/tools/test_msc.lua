--
-- tests/test_msc.lua
-- Automated test suite for the Microsoft C toolset interface.
-- Copyright (c) 2012-2013 Jason Perkins and the Premake project
--

	local suite = test.declare("tools_msc")

	local msc = premake.tools.msc


--
-- Setup/teardown
--

	local sln, prj, cfg

	function suite.setup()
		sln, prj = test.createsolution()
		kind "SharedLib"
	end

	local function prepare()
		cfg = test.getconfig(prj, "Debug")
	end


--
-- Check the optimization flags.
--

	function suite.cflags_onNoOptimize()
		optimize "Off"
		prepare()
		test.contains("/Od", msc.getcflags(cfg))
	end

	function suite.cflags_onOptimize()
		optimize "On"
		prepare()
		test.contains("/Ot", msc.getcflags(cfg))
	end

	function suite.cflags_onOptimizeSize()
		optimize "Size"
		prepare()
		test.contains("/O1", msc.getcflags(cfg))
	end

	function suite.cflags_onOptimizeSpeed()
		optimize "Speed"
		prepare()
		test.contains("/O2", msc.getcflags(cfg))
	end

	function suite.cflags_onOptimizeFull()
		optimize "Full"
		prepare()
		test.contains("/Ox", msc.getcflags(cfg))
	end

	function suite.cflags_onOptimizeDebug()
		optimize "Debug"
		prepare()
		test.contains("/Od", msc.getcflags(cfg))
	end

	function suite.cflags_onNoFramePointers()
		flags "NoFramePointer"
		prepare()
		test.contains("/Oy", msc.getcflags(cfg))
	end

	function suite.ldflags_onLinkTimeOptimizations()
		flags "LinkTimeOptimization"
		prepare()
		test.contains("/GL", msc.getldflags(cfg))
	end


--
-- Check handling of debugging support.
--

	function suite.ldflags_onSymbols()
		flags "Symbols"
		prepare()
		test.contains("/DEBUG", msc.getldflags(cfg))
	end


--
-- Check handling warnings and errors.
--

	function suite.cflags_OnNoWarnings()
		warnings "Off"
		prepare()
		test.contains("/W0", msc.getcflags(cfg))
	end

	function suite.cflags_OnExtraWarnings()
		warnings "Extra"
		prepare()
		test.contains("/W4", msc.getcflags(cfg))
	end

	function suite.cflags_OnFatalWarnings()
		flags "FatalWarnings"
		prepare()
		test.contains("/WX", msc.getcflags(cfg))
	end

	function suite.cflags_onSpecificWarnings()
		enablewarnings { "enable" }
		disablewarnings { "disable" }
		fatalwarnings { "fatal" }
		prepare()
		test.contains({ '/wd"disable"', '/we"fatal"' }, msc.getcflags(cfg))
	end

	function suite.ldflags_OnFatalWarnings()
		flags "FatalWarnings"
		prepare()
		test.contains("/WX", msc.getldflags(cfg))
	end


--
-- Check handling of library search paths.
--

	function suite.libdirs_onLibdirs()
		libdirs { "../libs" }
		prepare()
		test.contains('/LIBPATH:"../libs"', msc.getLibraryDirectories(cfg))
	end


--
-- Check handling of forced includes.
--

	function suite.forcedIncludeFiles()
		forceincludes { "include/sys.h" }
		prepare()
		test.contains('/FIinclude/sys.h', msc.getforceincludes(cfg))
	end


--
-- Check handling of floating point modifiers.
--

	function suite.cflags_onFloatingPointFast()
		floatingpoint "Fast"
		prepare()
		test.contains("/fp:fast", msc.getcflags(cfg))
	end

	function suite.cflags_onFloatingPointStrict()
		floatingpoint "Strict"
		prepare()
		test.contains("/fp:strict", msc.getcflags(cfg))
	end

	function suite.cflags_onSSE()
		vectorextensions "SSE"
		prepare()
		test.contains("/arch:SSE", msc.getcflags(cfg))
	end

	function suite.cflags_onSSE2()
		vectorextensions "SSE2"
		prepare()
		test.contains("/arch:SSE2", msc.getcflags(cfg))
	end

	function suite.cflags_onAVX()
		vectorextensions "AVX"
		prepare()
		test.contains("/arch:AVX", msc.getcflags(cfg))
	end

	function suite.cflags_onAVX2()
		vectorextensions "AVX2"
		prepare()
		test.contains("/arch:AVX2", msc.getcflags(cfg))
	end


--
-- Check the defines and undefines.
--

	function suite.defines()
		defines "DEF"
		prepare()
		test.contains({ '/D"DEF"' }, msc.getdefines(cfg.defines))
	end

	function suite.undefines()
		undefines "UNDEF"
		prepare()
		test.contains({ '/U"UNDEF"' }, msc.getundefines(cfg.undefines))
	end


--
-- Check compilation options.
--

	function suite.cflags_onNoMinimalRebuild()
		flags "NoMinimalRebuild"
		prepare()
		test.contains("/Gm-", msc.getcflags(cfg))
	end

	function suite.cflags_onMultiProcessorCompile()
		flags "MultiProcessorCompile"
		prepare()
		test.contains("/MP", msc.getcflags(cfg))
	end


--
-- Check handling of C++ language features.
--

	function suite.cflags_onExceptions()
		prepare()
		test.contains("/EHsc", msc.getcxxflags(cfg))
	end

	function suite.cflags_onNoExceptions()
		flags "NoExceptions"
		prepare()
		test.missing("/EHsc", msc.getcxxflags(cfg))
	end

	function suite.cflags_onNoRTTI()
		flags "NoRTTI"
		prepare()
		test.contains("/GR-", msc.getcxxflags(cfg))
	end


--
-- Check handling of additional linker options.
--

	function suite.ldflags_onOmitDefaultLibrary()
		flags "OmitDefaultLibrary"
		prepare()
		test.contains("/NODEFAULTLIB", msc.getldflags(cfg))
	end

	function suite.ldflags_onNoIncrementalLink()
		flags "NoIncrementalLink"
		prepare()
		test.contains("/INCREMENTAL:NO", msc.getldflags(cfg))
	end

	function suite.ldflags_onNoManifest()
		flags "NoManifest"
		prepare()
		test.contains("/MANIFEST:NO", msc.getldflags(cfg))
	end

	function suite.ldflags_onDLL()
		kind "SharedLib"
		prepare()
		test.contains("/DLL", msc.getldflags(cfg))
	end



--
-- Check handling of CLR settings.
--

	function suite.cflags_onClrOn()
		clr "On"
		prepare()
		test.contains("/clr", msc.getcflags(cfg))
	end

	function suite.cflags_onClrUnsafe()
		clr "Unsafe"
		prepare()
		test.contains("/clr", msc.getcflags(cfg))
	end

	function suite.cflags_onClrSafe()
		clr "Safe"
		prepare()
		test.contains("/clr:safe", msc.getcflags(cfg))
	end

	function suite.cflags_onClrPure()
		clr "Pure"
		prepare()
		test.contains("/clr:pure", msc.getcflags(cfg))
	end


--
-- Check handling of system search paths.
--

	function suite.includeDirs_onSysIncludeDirs()
		sysincludedirs { "/usr/local/include" }
		prepare()
		test.contains("-I/usr/local/include", msc.getincludedirs(cfg, cfg.includedirs, cfg.sysincludedirs))
	end

	function suite.libDirs_onSysLibDirs()
		syslibdirs { "/usr/local/lib" }
		prepare()
		test.contains('/LIBPATH:"/usr/local/lib"', msc.getLibraryDirectories(cfg))
	end
