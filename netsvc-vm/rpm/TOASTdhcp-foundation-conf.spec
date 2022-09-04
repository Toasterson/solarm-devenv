%define TOAST_APPLICATION dhcp
%define TOAST_LOGIN root
%define TOAST_GROUP root
%define TOAST_SERVICE %{TOAST_APPLICATION}d


Name: TOAST%{TOAST_APPLICATION}-foundation-conf
Version: 2022.08.29
Release: 01%{?dist}
Summary: DHCP configuration foundation for Kickstart and Jumpstart.
Group: Applications/System
BuildArch: noarch
License: public domain
URL: http://www.wegmueller.it/
Vendor: %{vendor}
Packager: Toasterson
Source0: %{name}.tar.xz
Provides: %{name} = %{version}-%{release} %{TOAST_APPLICATION} = %{version}-%{release}
AutoReqProv: off 
%if "%{_vendor}" == "suse"
BuildRequires: filesystem tar xz bash coreutils gawk sed grep
%endif
Requires: filesystem dhcp


%description
DHCP symbol definitions for remote  installation  via  Kickstart,
Jumpstart and iPXE.

These definitions can then be  used  to  define  boot  and  /  or  
install  configurations  for  Red  Hat Enterprise Linux, Solaris,
SmartOS or a generic illumos distribution.


%prep
umask 022
%setup -q -n %{name}


%build
umask 022


%install
umask 022
find etc -depth -print | cpio -pvdmu %{buildroot}


%clean
rm -rf %{buildroot} %{_builddir}/*


%post
%systemd_post %{TOAST_SERVICE}


%preun
%systemd_preun


%postun
%systemd_postun


%files
%defattr(0640, %{TOAST_LOGIN}, %{TOAST_GROUP}, -)
/etc/dhcpd.conf


%changelog
* Mon Aug 29 2022 Toasterson <toasterson@gmail.com> - 2022.08.29-01
- initial release.
