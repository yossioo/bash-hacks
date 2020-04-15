class ClassA:
    def __init__(self):
        print("clA initialized")


class ClassB(ClassA):
    def __init__(self):
        super(ClassA, self).__init__()
        print("clB initialized")


def main():
    # a = ClassA()
    b = ClassB()


if __name__ == "__main__":
    main()
