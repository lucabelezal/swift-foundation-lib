import os
import datetime
class TestCase:
    def __init__(self):
        self.name = ""
        self.functions = []
template ="""
//
//  {name}TestCase.swift
//
//
//  Created by lonnie on {date}.
//

import Foundation
import XCTest
@testable import FoundationLib

final class {name}TestCase: XCTestCase {
    func testSample() {
    
    }
}
"""
if __name__ == "__main__":
    date = datetime.date.today()
    date_str = "%d/%d/%d"%(date.year, date.month, date.day)
    items = __file__.split("/")
    file_directory = "/".join(items[:-1])
    base_path = "/".join(items[:-2])
    source_path = base_path + "/Sources/FoundationLib"
    test_path = base_path + "/Tests/FoundationLibTests"
    swift_files = []
    current_root = ""
    for array in os.walk(source_path):
        for item in array:
            if type(item) == list:
                for element in item:
                    if element.endswith(".swift"):
                        file_path = current_root + "/" + element
                        swift_files.append(file_path)
            else:
                current_root = item
    template_path = file_directory + "/" + "TemplateTests"
    for file in swift_files:
        item_path = test_path + file.split("FoundationLib")[1]
        name = item_path.split("/")[-1].split(".")[0]
        name = name.replace("+", "_")
        dir = "/".join(item_path.split("/")[:-1])
        if not os.path.exists(dir):
            os.mkdir(dir)
        final_path = dir + "/" + name + "TestCase.swift"
        content = template.replace("{name}", name).replace("{date}", date_str)
        with open(final_path, 'w') as f:
            f.write(content)
    manifests_path = test_path + "/" + "XCTestManifests.swift"
    current_root = ""
    swift_files = []
    for array in os.walk(test_path):
        for item in array:
            if type(item) == list:
                for element in item:
                    if element.endswith(".swift") and not element.endswith("XCTestManifests.swift"):
                        file_path = current_root + "/" + element
                        swift_files.append(file_path)
            else:
                current_root = item
    test_cases = []
    for file in swift_files:
        with open(file) as f:
            lines = f.readlines()
            begin = False
            test_case = TestCase()
            for line in lines:
                if line.__contains__("XCTestCase"):
                    begin = True
                    value = line.split("class ")
                    value.pop(0)
                    test_case.name = value[0].split(":")[0]
                else:
                    if begin == True:
                        if line.__contains__("func test"):
                            value = line.split(" ")
                            f_name = value[value.index("func") + 1]
                            if f_name.endswith("()"):
                                f_name = f_name.rstrip("()")
                                test_case.functions.append(f_name)
            if test_case.name != "":
                test_cases.append(test_case)

    manifests = "#if !canImport(ObjectiveC)\n"
    for test_case in test_cases:
        manifests += "extension " + test_case.name + " {\n"
        manifests += "\tstatic var allTests = [\n"
        for function in test_case.functions:
            manifests += "\t\t(\"{a}\", {b}),\n".format(a=function, b=function)
        manifests += "\t]\n"
        manifests += "}\n"
    manifests += "public func allTests() -> [XCTestCaseEntry] {\n\treturn [\n"
    for test_case in test_cases:
        manifests += "\t\ttestCase({name}.allTests),\n".format(name=test_case.name)
    manifests += """\t]\n}\n#endif\n"""
    with open(manifests_path, 'w') as f:
        f.write(manifests)

                
        



