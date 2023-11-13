{ lib
, stdenv
, fetchgit
, autoconf
, automake
, libtool
, pkg-config
, swig
, perl
, python3
, ncurses
, tcl
, libxml2
, gd
, libusb1
, readline
, boost
, perlPackages
, xmlSupport ? true
, pythonBindings ? true
, tclBindings ? true
, perlBindings ? true
}:

stdenv.mkDerivation rec {
  pname = "hamlib";
  version = "4.5.5";

  src = fetchgit {
    url = "https://github.com/${pname}/${pname}.git";
    rev = "refs/tags/${version}";
    sha256 = "sha256-XLoNy+A0oNKGlQEVcevOTFHg71jJldr2r8rn88An5/w=";
  };

  preConfigure = ''
    ./bootstrap
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    swig
  ] ++ lib.optionals perlBindings [ perl ]
    ++ lib.optionals tclBindings [ tcl ]
    ++ lib.optionals perlBindings [ python3 ];  

  buildInputs = [
    readline
    ncurses
    gd
    libusb1
    boost
  ] ++ lib.optionals perlBindings [ perl perlPackages.ExtUtilsMakeMaker ]
    ++ lib.optionals tclBindings [ tcl ]
    ++ lib.optionals pythonBindings [ python3 ]
    ++ lib.optionals xmlSupport [ libxml2 ];
    

  configureFlags = lib.optionals perlBindings [ "--with-perl-binding" ]
    ++ lib.optionals tclBindings [ "--with-tcl-binding" "--with-tcl=${tcl}/lib/" ]
    ++ lib.optionals pythonBindings [ "--with-python-binding" ]
    ++ lib.optionals xmlSupport [ "--with-xml-support"];

  meta = with lib; {
    description = "Runtime library to control radio transceivers and receivers";
    longDescription = ''
    Hamlib provides a standardized programming interface that applications
    can use to send the appropriate commands to a radio.

    Also included in the package is a simple radio control program 'rigctl',
    which lets one control a radio transceiver or receiver, either from
    command line interface or in a text-oriented interactive interface.
    '';
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    homepage = "https://hamlib.sourceforge.net";
    maintainers = with maintainers; [ relrod ];
    platforms = with platforms; unix;
  };
}
