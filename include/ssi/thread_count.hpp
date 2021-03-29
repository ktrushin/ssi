#ifndef SSI_THREAD_COUNT_HPP
#define SSI_THREAD_COUNT_HPP

/// My namespace
namespace ssi {
/// @brief Get the number of parallel threads of execution.
///
/// @return number of parallel threads
///
/// @exception_guarantee noexcept
/// @side_effects none
[[gnu::visibility("default")]] unsigned int thread_count() noexcept;
}  // namespace ssi

#endif  // SSI_THREAD_COUNT_HPP
