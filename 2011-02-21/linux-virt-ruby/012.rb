    require 'libvirt'
    
    new_dom_xml = <<-EOF
    <domain type='kvm'>
      <name>ruby-libvirt-tester</name>
      <memory>1048576</memory>
      <vcpu>1</vcpu>
      <os>
        <type arch='x86_64'>hvm</type>
      </os>
      <on_poweroff>destroy</on_poweroff>
      <on_reboot>restart</on_reboot>
      <on_crash>restart</on_crash>
      <devices>
      ...
      </devices>
    </domain>
    EOF
    
    conn = Libvirt::open('qemu:///system')
    dom = conn.define_domain_xml(new_dom_xml)
    dom.create
    
    begin
      dom.undefine
    rescue => e
      puts e
    end
    dom.destroy
    dom.undefine
    conn.close
