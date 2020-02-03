#ifndef SSI_THREAD_COUNT_HPP
#define SSI_THREAD_COUNT_HPP

namespace ssi {
// Returns the number of parallel threads of execution.
__attribute__((__visibility__("default"))) unsigned int thread_count() noexcept;
}  // namespace ssi

#endif  // SSI_THREAD_COUNT_HPP
