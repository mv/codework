
for f in `rpm -qa --qf "%{name}\n"|sort|uniq`
do
  echo "- $f"
  rpm -q --qf "  +- %-20{name} %-20{version} %{name}-%{version}.%{arch}\n" --whatrequires $f | sort | uniq
done | grep -v 'no packages'



