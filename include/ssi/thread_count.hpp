#ifndef SSI_THREAD_COUNT_HPP
#define SSI_THREAD_COUNT_HPP

/// My namespace
namespace ssi {
/**
 * @brief Get the number of parallel threads of execution.
 *
 * @note [Here](https://developer.lsst.io/cpp/api-docs.html#documenting-c-code)
 * and [here](http://epic-alfa.kavli.tudelft.nl/share/doc/libstdc++-docs-4.4.7/
 * html/manual/documentation_style.html) they recommend to use JavaDoc style
 * for block comments and triple forward slash style for one-line comments.
 * Such an approach may arguably minimize the probability of breaking the
 * formatting in the doxygen output, be it either HTML, XML or anything else.
 * This project follows that recommendation. Please see one line comment
 * (triple forward slash style) for the `ssi` namespace and the comment for
 * this function (JavaDoc style).
 *
 * @returns number of parallel threads
 *
 * @exception_guarantee noexcept
 * @side_effects none
 */
[[gnu::visibility("default")]] unsigned int thread_count() noexcept;
}  // namespace ssi

#endif  // SSI_THREAD_COUNT_HPP
