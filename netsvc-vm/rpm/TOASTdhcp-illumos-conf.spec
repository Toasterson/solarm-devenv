%define TOAST_APPLICATION dhcp
%define TOAST_LOGIN root
%define TOAST_GROUP root
%define TOAST_SERVICE %{TOAST_APPLICATION}d


Name: TOAST%{TOAST_APPLICATION}-illumos-conf
Version: 2022.08.30
Release: 01%{?dist}
Summary: DHCP configuration for booting illumos over the network.
Group: Applications/System
BuildArch: noarch
License: public domain
URL: http://www.inter.net/
Vendor: %{vendor}
Packager: Toasterson
Source0: %{name}.tar.xz
Provides: %{name} = %{version}-%{release} %{TOAST_APPLICATION} = %{version}-%{release}
AutoReqProv: off 
%if "%{_vendor}" == "suse"
BuildRequires: filesystem tar xz bash coreutils
Requires: filesystem systemd dhcp dhcp-server
%endif
Requires: TOASTdhcp-foundation-conf >= 2022.08.29


%description
DHCP configuration for booting illumos over the network.


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
awk '
/dhcpd-illumos\.conf";/ \
{
        next;
}

{
        Buffer = Buffer $0 ORS;
}

END \
{
        Buffer = Buffer "include \"/etc/dhcpd-illumos.conf\";" ORS;

        printf("%s", Buffer) > FILENAME;
        close(FILENAME);
}' /etc/dhcpd.conf
%systemd_post %{TOAST_SERVICE}
systemctl enable %{TOAST_SERVICE}


%preun
if [ $1 -eq 1 ]
then
        #
        # This is a removal, not an in-place upgrade.
        #
        awk '
        /dhcpd-illumos\.conf";/ \
        {
                next;
        }

        {
                Buffer = Buffer $0 ORS;
        }

        END \
        {
                printf("%s", Buffer) > FILENAME;
                close(FILENAME);
        }' /etc/dhcpd.conf
fi
%systemd_preun


%postun
%systemd_postun


        # This is a removal, not an in-place upgrade.
        #
        awk '
        /dhcpd-illumos\.conf";/ \
        {
                next;
        }

        {
                Buffer = Buffer $0 ORS;
        }

        END \
        {
                printf("%s", Buffer) > FILENAME;
                close(FILENAME);
        }' /etc/dhcpd.conf
fi
%systemd_preun


%files
%defattr(0640, %{TOAST_LOGIN}, %{TOAST_GROUP}, -)
/etc/dhcpd-illumos.conf


%changelog
* Tue Aug 30 2022 Toasterson <toasterson@gmail.com> - 2022.08.30-01
- initial release.