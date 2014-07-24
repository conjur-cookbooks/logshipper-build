if node.platform_family == 'debian'
  include_recipe "apt::default"

  %w(
    g++ make cmake libjsoncpp-dev libboost-filesystem-dev libboost-regex-dev
    libcurl4-gnutls-dev unzip libboost-program-options-dev dpkg-dev
  ).each do |pkg|
    package pkg
  end

  if [node.platform, node.platform_version] == %w(ubuntu 12.04)
    if node.kernel.machine == 'x86_64'
      arch = 'amd64'
      build = 5143781
    elsif node.kernel.machine == 'i386'
      arch = 'i386'
      build = 5143784
    else
      raise "architecture not supported"
    end

    deb = "#{Chef::Config[:file_cache_path]}/libyaml-cpp.deb"
    devdeb = "#{Chef::Config[:file_cache_path]}/libyaml-cpp-dev.deb"

    remote_file deb do
      source "https://launchpad.net/ubuntu/+source/yaml-cpp/0.5.1-1/+build/#{build}/+files/libyaml-cpp0.5_0.5.1-1_#{arch}.deb"
      checksum '17a4d77e673f57585ba878255661632a218d635e31584fe6cb9b196bc073c6e5'
    end

    remote_file devdeb do
      source "https://launchpad.net/ubuntu/+source/yaml-cpp/0.5.1-1/+build/#{build}/+files/libyaml-cpp-dev_0.5.1-1_#{arch}.deb"
      checksum 'beddc02bd0709683c04a2eecf30b50194c16cb9ad0e6368b0274c365f5a65a6a'
    end
  end

  package 'libyaml-cpp' do
    if deb
      source deb
      provider Chef::Provider::Package::Dpkg
    end
  end

  package 'libyaml-cpp-dev' do
    if devdeb
      source devdeb
      provider Chef::Provider::Package::Dpkg
    end
  end
else
  raise "platform not supported"
end
