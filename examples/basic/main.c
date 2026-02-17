#include <pci/pci.h>
#include <stdio.h>

int main(void) {
  struct pci_access *pacc;
  struct pci_dev *dev;

  pacc = pci_alloc();
  pci_init(pacc);
  pci_scan_bus(pacc);

  for (dev = pacc->devices; dev; dev = dev->next) {
    pci_fill_info(dev, PCI_FILL_IDENT | PCI_FILL_BASES | PCI_FILL_CLASS);
    printf("Found device %04x:%04x\n", dev->vendor_id, dev->device_id);
  }

  pci_cleanup(pacc);
  return 0;
}
