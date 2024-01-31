from glyphsLib import load, to_designspace
from ufo2ft.featureCompiler import FeatureCompiler, parseLayoutFeatures
from fontTools.feaLib import ast
import argparse


class Checker:
    def __init__(self, sources):
        self.masters = []
        for source in sources:
            self.masters.append(
                {
                    "ufo": source.font,
                    "name": source.name,
                    "compiler": FeatureCompiler(source.font),
                }
            )
            self.masters[-1]["writers"] = self.masters[-1]["compiler"].featureWriters

    def check_all_the_same(self, items, description, print_items=None):
        if all(i == items[0] for i in items[1:]):
            return True
        print(" MERGE PROBLEM: Not all masters " + description + ":")
        if print_items is not None:
            items = print_items
        for master, item in zip(self.masters, items):
            print("  %s: %s" % (master["name"], item))
        print("\n")
        return False


parser = argparse.ArgumentParser(description="Debug a merge error in a Glyphs file")
parser.add_argument(
    "glyphs_file", metavar="glyphs_file", type=str, help="The Glyphs file to debug"
)
args = parser.parse_args()
print("Converting to UFO")
ds = to_designspace(load(args.glyphs_file), minimal=True)
checker = Checker(ds.sources)

for writers in zip(*[m["writers"] for m in checker.masters]):
    features = writers[0].features
    # Start a new feature file for each master
    written = []
    for writer, master in zip(writers, checker.masters):
        master["featurefile"] = parseLayoutFeatures(master["ufo"])
        written.append(writer.write(master["ufo"], master["featurefile"]))
    if not written[0]:
        continue
    print(
        "Checking compatibility of %s feature%s"
        % ("/".join(features), "s" if len(features) > 1 else "")
    )
    if not checker.check_all_the_same(
        ["yes" if w else "no" for w in written], " had this feature"
    ):
        continue
    # Now check compatibility of each feature file. Normally the problem is
    # incompatible lookups
    feature_files = [m["featurefile"] for m in checker.masters]
    lookups_by_name = [
        {s.name: s for s in f.statements if isinstance(s, ast.LookupBlock)}
        for f in feature_files
    ]
    all_lookup_names = set()
    for names in lookups_by_name:
        all_lookup_names.update(names.keys())
    for lookup in all_lookup_names:
        checker.check_all_the_same(
            ["yes" if lookup in my_lookups else "no" for my_lookups in lookups_by_name],
            "had a %s lookup" % lookup,
            print_items=[
                my_lookups[lookup].asFea() if lookup in my_lookups else "<Missing>"
                for my_lookups in lookups_by_name
            ],
        )
