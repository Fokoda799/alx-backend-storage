fn = "test"


def test(**args):
   print(args)

print(test.__qualname__)