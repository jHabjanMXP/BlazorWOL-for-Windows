using System;
using System.ComponentModel.DataAnnotations;

namespace BlazorWOL.Shared
{
    public class Device
    {
        public Guid Id { get; set; } = Guid.NewGuid();

        [Required(ErrorMessage = "Please enter a device name.")]
        [StringLength(20, ErrorMessage = "Device name must be 20 characters or less.")]
        public string Name { get; set; }

        [Required(ErrorMessage = "Please enter a MAC address.")]
        [RegularExpression(@"(?i)^[\da-f]{2}((:|-)[\da-f]{2}){5}$", ErrorMessage = "Invalid MAC address format.")]
        public string MACAddress { get; set; }
    }
}
