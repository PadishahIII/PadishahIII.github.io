## Scan all decorators under a package


> [!question] questioin
> in python, given a package name like "Core.Beans", i want to scan all python modules under this package recursively and extract all python class infomation including decorators like "@Bean", class name, class members, decorators on class members, and other infos about this class. in sum, i want to get all decorators and the class or member they decorate.

To scan all Python modules under a package recursively and extract information about the classes and their decorators, we can use the `pkgutil` and `inspect` modules from the Python standard library.

Here's an example of how we might implement this functionality:

```python
import pkgutil
import inspect

def scan_package(package_name):
    package = __import__(package_name, fromlist=[''])

    for importer, modname, ispkg in pkgutil.walk_packages(path=package.__path__,
                                                          prefix=package.__name__ + '.',
                                                          onerror=lambda x: None):
        module = __import__(modname, fromlist=[''])

        for name, obj in inspect.getmembers(module):
            if inspect.isclass(obj):
                class_decorators = []
                member_decorators = {}

                for decorator in obj.__dict__.get('__decorators__', []):
                    if inspect.isclass(decorator):
                        class_decorators.append(decorator.__name__)
                    elif inspect.isfunction(decorator):
                        member_decorators[decorator.__name__] = []

                for name, member in inspect.getmembers(obj):
                    if inspect.isfunction(member) and name != '__init__':
                        for decorator in member.__dict__.get('__decorators__', []):
                            if inspect.isfunction(decorator):
                                member_decorators[member.__name__].append(decorator.__name__)

                print(f"Class: {obj.__name__}")
                print(f"Class decorators: {class_decorators}")
                print(f"Member decorators: {member_decorators}")
```

In this example, we define a function called `scan_package` that takes a package name as an argument. We use the `__import__` function to import the package and the `pkgutil.walk_packages` function to recursively walk through all modules under the package.

For each module, we use the `inspect.getmembers` function to get all members of the module. We then filter the members to only include classes using the `inspect.isclass` function.

For each class, we extract any decorators that are defined on the class or its members. We do this by looking for a special `__decorators__` attribute on the class or member. If this attribute is defined, we iterate over its contents and extract any class or function objects that represent decorators.

We then print out information about the class, including its name, any decorators that are defined on the class, and any decorators that are defined on its members.

Note that this implementation assumes that decorators are defined using a special `__decorators__` attribute on the class or member. This is not a standard Python feature, so you would need to define this attribute yourself in order to use this implementation.


## Interface AbstractMethod


> [!questioin] question
> in python, how to define an interface with an abstract function and when a class B implement the interface, it must implement the certain function otherwise that would throw exception or one can check whether B has implemented abstract method or not


In Python, we can define an interface using an abstract base class (ABC) from the `abc` module. An ABC is a class that cannot be instantiated directly, but can be subclassed to provide concrete implementations of its abstract methods.

Here's an example of how we might define an interface with an abstract method using an ABC:

```python
from abc import ABC, abstractmethod

class Interface(ABC):
    @abstractmethod
    def do_something(self):
        pass

class B(Interface):
    def do_something(self):
        print("Doing something...")

b = B()
b.do_something()
```

In this example, we define an interface called `Interface` that extends the `ABC` class from the `abc` module. We define a single abstract method called `do_something`.

We then define a concrete class called `B` that implements the `Interface` interface. The `B` class provides a concrete implementation of the `do_something` method.

When we create a new instance of the `B` class and call the `do_something` method, it will print `"Doing something..."`.

If we define a new class that extends the `Interface` interface but does not provide a concrete implementation of the `do_something` method, attempting to create an instance of that class will raise a `TypeError` with a message indicating that the class does not implement the abstract method:

```python
class C(Interface):
    pass

c = C() # Raises TypeError: Can't instantiate abstract class C with abstract methods do_something
```

Alternatively, we can check whether a class has implemented an abstract method using the `isinstance` function and the `collections.abc.Callable` class from the `collections.abc` module:

```python
from collections.abc import Callable

class C:
    def do_something(self):
        print("Doing something...")

if isinstance(C().do_something, Callable):
    print("C implements do_something")
else:
    print("C does not implement do_something")
```

In this example, we define a new class called `C` that provides a concrete implementation of the `do_something` method. We then check whether the `do_something` method is an instance of the `Callable` class from the `collections.abc` module. If it is, we print `"C implements do_something"`. If it is not, we print `"C does not implement do_something"`.

## IoC (Inversion of Control) Container implementation

Sure, here's an example of how we might implement an IoC container in Python to manage object dependencies and perform Dependency Injection:

```python
class Container:
    def __init__(self):
        self.dependencies = {}

    def register(self, cls, *args, **kwargs):
        self.dependencies[cls] = (args, kwargs)

    def resolve(self, cls):
        if cls not in self.dependencies:
            raise Exception(f"No registered dependency found for {cls.__name__}")
        args, kwargs = self.dependencies[cls]
        dependencies = [self.resolve(arg) if isinstance(arg, type) else arg for arg in args]
        return cls(*dependencies, **kwargs)

class Parser:
    def __init__(self, filename):
        self.filename = filename

class B:
    def __init__(self, parser):
        self.parser = parser

container = Container()
container.register(Parser, "example.txt")
container.register(B, container.resolve(Parser))

b = container.resolve(B)
print(b.parser.filename)
```

In this example, we define a `Container` class that is responsible for managing object dependencies and performing Dependency Injection. The `Container` class contains a dictionary called `dependencies` that is used to store the dependencies for each class.

The `register` method is used to register a new dependency with the `Container`. The method takes a class object (`cls`) and any additional arguments and keyword arguments that are required to create an instance of the class. The method stores the arguments and keyword arguments in the `dependencies` dictionary.

The `resolve` method is used to resolve a dependency from the `Container`. The method takes a class object (`cls`) and recursively resolves any dependencies that are required to create an instance of the class. The method returns a new instance of the class with the resolved dependencies.

We then define a `Parser` class and a `B` class. The `Parser` class takes a `filename` argument in its constructor, and the `B` class takes a `parser` argument in its constructor.

We create a new instance of the `Container` class and register a `Parser` object with a `"example.txt"` filename argument. We also register a `B` object with a resolved `Parser` object.

We then resolve a new instance of the `B` class from the `Container`. The `Container` resolves the `Parser` object first, and then uses the resolved `Parser` object to create a new instance of the `B` class.

This implementation provides a simple IoC container that can be used to manage object dependencies and perform Dependency Injection in Python.

## Using Context

> [!question] question
> i'm programming a python development structure, i want to use Context to maintain every instance that would be reused by other classes, how to make it in an optimize way. give me code which in producement environment

If the `Parser` class requires additional parameters in its constructor, you can modify the `get_instance` method in the `Context` class to accept additional arguments and pass them to the constructor of the specified class. Here's an updated implementation of the `Context` class that supports passing arguments to the constructor of the specified class:

```python
class Context:
    def __init__(self):
        self.instances = {}

    def get_instance(self, cls, *args, **kwargs):
        if cls not in self.instances:
            self.instances[cls] = cls(self, *args, **kwargs)
        return self.instances[cls]
```

In this updated implementation, the `get_instance` method now accepts `*args` and `**kwargs` arguments. These arguments are passed to the constructor of the specified class when a new instance is created.

Here's an example usage of the updated `Context` class with a `Parser` class that requires additional parameters in its constructor:

```python
class Parser:
    def __init__(self, context, filename):
        self.context = context
        self.filename = filename

class B:
    def __init__(self, context):
        self.parser = context.get_instance(Parser, "example.txt")

context = Context()
b = B(context)
```

In this updated example, we define a `Parser` class that takes a `Context` object and a `filename` argument in its constructor. We also define a `B` class that takes a `Context` object as an argument and uses the `get_instance` method to get an instance of the `Parser` class with a `"example.txt"` filename argument.

When we create a new instance of the `B` class, we pass in a `Context` object. The `B` class then uses the `get_instance` method to get an instance of the `Parser` class with a `"example.txt"` filename argument from the `Context` object. If an instance of the `Parser` class has not already been created, the `Context` object creates a new instance and adds it to the `instances` dictionary. If an instance of the `Parser` class has already been created, the `Context` object returns the existing instance from the `instances` dictionary.

This updated implementation allows us to maintain a single instance of each object that can be reused by other classes, while also supporting passing additional arguments to the constructor of each specified class.

## Circular import Problem
- One of the solutions is merge the two modules that import each other
- Other solution is just placing the import within function where the module is up to use.
