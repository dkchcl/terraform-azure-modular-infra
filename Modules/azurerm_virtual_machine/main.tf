resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.vms

  name                  = each.value.vm_name
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  network_interface_ids = [data.azurerm_network_interface.nic[each.key].id, ]
  size                  = each.value.size

  os_disk {
    caching                          = each.value.os_disk.caching
    storage_account_type             = try(each.value.os_disk.storage_account_type, null)
    name                             = try(each.value.os_disk.name, null)
    disk_size_gb                     = try(each.value.os_disk.disk_size_gb, null)
    disk_encryption_set_id           = try(each.value.os_disk.disk_encryption_set_id, null)
    secure_vm_disk_encryption_set_id = try(each.value.os_disk.secure_vm_disk_encryption_set_id, null)
    security_encryption_type         = try(each.value.os_disk.security_encryption_type, null)
    write_accelerator_enabled        = try(each.value.os_disk.write_accelerator_enabled, null)

    dynamic "diff_disk_settings" {
      for_each = try(each.value.os_disk.diff_disk_settings, null) == null ? [] : [each.value.os_disk.diff_disk_settings]
      content {
        option    = diff_disk_settings.value.option
        placement = try(diff_disk_settings.value.placement, null)
      }
    }
  }

  # Optional arguments
  admin_username                                         = data.azurerm_key_vault_secret.kvs[each.key].id
  admin_password                                         = data.azurerm_key_vault_secret.kvs1[each.key].id
  disable_password_authentication                        = try(each.value.disable_password_authentication, null)
  computer_name                                          = try(each.value.computer_name, null)
  allow_extension_operations                             = try(each.value.allow_extension_operations, null)
  availability_set_id                                    = try(each.value.availability_set_id, null)
  license_type                                           = try(each.value.license_type, null)
  capacity_reservation_group_id                          = try(each.value.capacity_reservation_group_id, null)
  dedicated_host_id                                      = try(each.value.dedicated_host_id, null)
  dedicated_host_group_id                                = try(each.value.dedicated_host_group_id, null)
  encryption_at_host_enabled                             = try(each.value.encryption_at_host_enabled, null)
  eviction_policy                                        = try(each.value.eviction_policy, null)
  max_bid_price                                          = try(each.value.max_bid_price, null)
  patch_mode                                             = try(each.value.patch_mode, null)
  patch_assessment_mode                                  = try(each.value.patch_assessment_mode, null)
  bypass_platform_safety_checks_on_user_schedule_enabled = try(each.value.bypass_platform_safety_checks_on_user_schedule_enabled, null)
  reboot_setting                                         = try(each.value.reboot_setting, null)
  priority                                               = try(each.value.priority, null)
  secure_boot_enabled                                    = try(each.value.secure_boot_enabled, null)
  vtpm_enabled                                           = try(each.value.vtpm_enabled, null)
  user_data                                              = try(each.value.user_data, null)
  zone                                                   = try(each.value.zone, null)
  disk_controller_type                                   = try(each.value.disk_controller_type, null)
  edge_zone                                              = try(each.value.edge_zone, null)
  extensions_time_budget                                 = try(each.value.extensions_time_budget, null)
  platform_fault_domain                                  = try(each.value.platform_fault_domain, null)
  provision_vm_agent                                     = try(each.value.provision_vm_agent, null)
  proximity_placement_group_id                           = try(each.value.proximity_placement_group_id, null)
  source_image_id                                        = try(each.value.source_image_id, null)
  os_managed_disk_id                                     = try(each.value.os_managed_disk_id, null)
  virtual_machine_scale_set_id                           = try(each.value.virtual_machine_scale_set_id, null)
  tags                                                   = try(each.value.tags, null)

  # SSH Keys
  dynamic "admin_ssh_key" {
    for_each = try(each.value.admin_ssh_key, null) == null ? [] : [each.value.admin_ssh_key]
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  # Boot Diagnostics
  dynamic "boot_diagnostics" {
    for_each = try(each.value.boot_diagnostics, null) == null ? [] : [each.value.boot_diagnostics]
    content {
      storage_account_uri = try(boot_diagnostics.value.storage_account_uri, null)
    }
  }

  # Identity
  dynamic "identity" {
    for_each = try(each.value.identity, null) == null ? [] : [each.value.identity]
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  # Plan
  dynamic "plan" {
    for_each = try(each.value.plan, null) == null ? [] : [each.value.plan]
    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  # Additional Capabilities
  dynamic "additional_capabilities" {
    for_each = try(each.value.additional_capabilities, null) == null ? [] : [each.value.additional_capabilities]
    content {
      ultra_ssd_enabled   = try(additional_capabilities.value.ultra_ssd_enabled, null)
      hibernation_enabled = try(additional_capabilities.value.hibernation_enabled, null)
    }
  }

  # Gallery Application
  dynamic "gallery_application" {
    for_each = try(each.value.gallery_application, null) == null ? [] : [each.value.gallery_application]
    content {
      version_id                                  = gallery_application.value.version_id
      automatic_upgrade_enabled                   = try(gallery_application.value.automatic_upgrade_enabled, null)
      configuration_blob_uri                      = try(gallery_application.value.configuration_blob_uri, null)
      order                                       = try(gallery_application.value.order, null)
      tag                                         = try(gallery_application.value.tag, null)
      treat_failure_as_deployment_failure_enabled = try(gallery_application.value.treat_failure_as_deployment_failure_enabled, null)
    }
  }

  # Secrets
  dynamic "secret" {
    for_each = try(each.value.secret, null) == null ? [] : [each.value.secret]
    content {
      key_vault_id = secret.value.key_vault_id
      dynamic "certificate" {
        for_each = secret.value.certificate
        content {
          url = certificate.value.url
        }
      }
    }
  }

  # Source Image Reference
  dynamic "source_image_reference" {
    for_each = try(each.value.source_image_reference, null) == null ? [] : [each.value.source_image_reference]
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  # OS Image Notification
  dynamic "os_image_notification" {
    for_each = try(each.value.os_image_notification, null) == null ? [] : [each.value.os_image_notification]
    content {
      timeout = try(os_image_notification.value.timeout, null)
    }
  }

  # Termination Notification
  dynamic "termination_notification" {
    for_each = try(each.value.termination_notification, null) == null ? [] : [each.value.termination_notification]
    content {
      enabled = termination_notification.value.enabled
      timeout = try(termination_notification.value.timeout, null)
    }
  }

  # 🚀 Nginx Install script
  custom_data = base64encode(<<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

cat <<EOT | sudo tee /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>🚀 DevOps Mastery Course</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(to right, #f2f2f2, #e6f7ff);
      margin: 0;
      padding: 0;
      color: #333;
    }
    header {
      background-color: #007acc;
      color: white;
      padding: 20px 40px;
      text-align: center;
    }
    header h1 {
      font-size: 36px;
    }
    section {
      padding: 30px 40px;
    }
    .section-title {
      font-size: 28px;
      margin-bottom: 10px;
      color: #007acc;
    }
    .course-details, .syllabus, .instructor, .contact {
      background-color: #ffffff;
      padding: 20px;
      border-radius: 10px;
      margin-bottom: 30px;
      box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
    }
    ul {
      padding-left: 20px;
    }
    .contact form {
      display: flex;
      flex-direction: column;
    }
    .contact input, .contact textarea {
      margin-bottom: 15px;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 6px;
    }
    .contact button {
      background-color: #007acc;
      color: white;
      padding: 10px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 16px;
    }
    .contact button:hover {
      background-color: #005f99;
    }
    footer {
      text-align: center;
      padding: 15px;
      background-color: #007acc;
      color: white;
    }
  </style>
</head>
<body>
  <header>
    <h1>🚀 DevOps Mastery Course</h1>
    <p>📚 Learn DevOps from Scratch & Become a Pro!</p>
  </header>
  <section>
    <div class="course-details">
      <h2 class="section-title">📋 Course Overview</h2>
      <p>Welcome to the <strong>DevOps Mastery Course</strong> 🌟 — your gateway to mastering automation, CI/CD, Docker, Kubernetes, Jenkins, and more! Perfect for developers, sysadmins, and IT enthusiasts who want to streamline development and operations. 👨‍💻👩‍💻</p>
    </div>
    <div class="syllabus">
      <h2 class="section-title">📚 Syllabus</h2>
      <ul>
        <li>🔧 Introduction to DevOps</li>
        <li>🐧 Linux Basics for DevOps</li>
        <li>🛠️ CI/CD Pipelines</li>
        <li>🐳 Docker & Containers</li>
        <li>☸️ Kubernetes Basics</li>
        <li>🔐 Security & Monitoring</li>
        <li>🧪 Testing and Automation</li>
        <li>☁️ Cloud Integration (AWS, Azure)</li>
      </ul>
    </div>
    <div class="instructor">
      <h2 class="section-title">👨‍🏫 Instructor</h2>
      <p><strong>Mr. Ashish Kumar</strong> – Senior DevOps Engineer with 17+ years of experience in cloud, automation & infrastructure management. 🧠✨</p>
      <p><strong>Mr. Aman Gupta</strong> – Senior DevOps Engineer with 15+ years of experience in cloud, automation & infrastructure management. 🧠✨</p>
    </div>   
    <div class="course-details">
      <h2 class="section-title">⏳ Duration & Mode</h2>
      <ul>
        <li>🕒 Duration: 8 Weeks</li>
        <li>🌐 Mode: Online (Live + Recordings)</li>
        <li>📅 Next Batch: 1st October 2025</li>
      </ul>
    </div>
    <div class="contact">
      <h2 class="section-title">📞 Contact Us</h2>
      <form action="#" method="POST">
        <input type="text" name="name" placeholder="👤 Your Name" required />
        <input type="email" name="email" placeholder="📧 Your Email" required />
        <input type="tel" name="phone" placeholder="📱 Phone Number" />
        <textarea name="message" rows="4" placeholder="💬 Your Message"></textarea>
        <button type="submit">📨 Submit</button>
      </form>
    </div>
  </section>
  <footer>
    <p>© 2025 DevOps Academy 🚀 | Built with ❤️ by ChatGPT</p>
  </footer>
</body>
</html>
EOT
EOF
  )
}
























