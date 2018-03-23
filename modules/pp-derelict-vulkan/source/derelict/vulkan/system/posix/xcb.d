/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/

module derelict.vulkan.system.posix.xcb;
version (VK_USE_PLATFORM_XCB_KHR):
extern(System):

public {
  import derelict.vulkan.base;
  import derelict.vulkan.types;
}

import xcb.xcb;
enum VK_KHR_xcb_surface = 1;
enum VK_KHR_XCB_SURFACE_SPEC_VERSION   = 6;
enum VK_KHR_XCB_SURFACE_EXTENSION_NAME = "VK_KHR_xcb_surface";

alias VkXcbSurfaceCreateFlagsKHR = VkFlags;

struct VkXcbSurfaceCreateInfoKHR {
  VkStructureType            sType     ;
  const(void)*               pNext     ;
  VkXcbSurfaceCreateFlagsKHR flags     ;
  xcb_connection_t*          connection;
  xcb_window_t               window    ;
}

alias PFN_vkCreateXcbSurfaceKHR = nothrow 
    VkResult function( VkInstance                        instance
                     , const(VkXcbSurfaceCreateInfoKHR)* pCreateInfo
                     , const(VkAllocationCallbacks)*     pAllocator
                     , VkSurfaceKHR*                     pSurface );
alias PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR = nothrow 
    VkBool32 function( VkPhysicalDevice  physicalDevice
                     , uint              queueFamilyIndex
                     , xcb_connection_t* connection
                     , xcb_visualid_t    visual_id );

mixin template XCBFunctions() {
  PFN_vkCreateXcbSurfaceKHR                        vkCreateXcbSurfaceKHR;
  PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR vkGetPhysicalDeviceXcbPresentationSupportKHR;
  pragma(inline, true)
  void bindFunctionsXCB(alias bind)() {
    bind(cast(void**)&vkCreateXcbSurfaceKHR, "vkCreateXcbSurfaceKHR");
    bind( cast(void**)&vkGetPhysicalDeviceXcbPresentationSupportKHR
        , "vkGetPhysicalDeviceXcbPresentationSupportKHR" );
  }
}

version (none) {
  VkResult vkCreateXcbSurfaceKHR( VkInstance                        instance
                                , const(VkXcbSurfaceCreateInfoKHR)* pCreateInfo
                                , const(VkAllocationCallbacks)*     pAllocator
                                , VkSurfaceKHR*                     pSurface );
  VkBool32 vkGetPhysicalDeviceXcbPresentationSupportKHR( VkPhysicalDevice  physicalDevice
                                                       , uint              queueFamilyIndex
                                                       , xcb_connection_t* connection
                                                       , xcb_visualid_t    visual_id);
}
