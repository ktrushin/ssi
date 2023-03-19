#include <iostream>

#include <boost/program_options.hpp>

#include "version.hpp"
#include "ssi/local_time.hpp"
#include "ssi/thread_count.hpp"

int main(int argc, const char* argv[]) {
  namespace po = boost::program_options;
  po::options_description opt_desc{"Options"};
  // clang-format off
  opt_desc.add_options()
    ("help,h", "Print the help message")
    ("version,v", "Print version");
  // clang-format on

  // NOLINTNEXTLINE(readability-identifier-length)
  po::variables_map vm;

  try {
    po::store(po::parse_command_line(argc, argv, opt_desc), vm);
    po::notify(vm);
  } catch (const boost::program_options::error& e) {
    std::cerr << e.what() << std::endl;
    return 1;
  }

  if (vm.find("help") != vm.end()) {
    constexpr const char* desc_msg =
        "Description:\n"
        "  Utility which prints some symtem information.\n\n"
        "Usage:\n"
        "  ssi [options]";
    constexpr const char* example_msg =
        "Examples:\n"
        "  prompt> ssi\n"
        "  Number of threads: 4\n"
        "  Local time: 2022-Sep-04 12:50:58";
    std::cout << desc_msg << "\n\n"
              << opt_desc << "\n"
              << example_msg << std::endl;
    return 0;
  }
  if (vm.find("version") != vm.end()) {
    std::cout << common::version << std::endl;
    return 0;
  }

  std::cout << "Number of threads: " << ssi::thread_count()
            << "\nLocal time: " << ssi::local_time() << std::endl;
  return 0;
}
