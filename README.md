# `SOSFactory` : Factory classes for sum-of-squares programming

Today, different solvers for MATLAB exist for convex sum-of-squares problems. Most of these toolboxes bring their own implementation of a polynomial type. They also come with individual interfaces for both constraints and solutions.

The `SOSFactory` toolbox aims to provide a unified interface for polynomials, constraints, and solvers. *It does not provide a polynomial class or a sum-of-squares solver itself.* Instead, the relevant third-party source files must be accessible to MATLAB throughout the application.

## Usage & Description

At its core, for each pair of SOS solver / polynomial implementation, three classes provide the common interface:

- **Factory** : The factory class, with its interface defined in [`AbstractSOSFactory.m`](/AbstractSOSFactory.m), constitutes the entry-point for each solver. It provides basic polynomial operations (such as constructors, computation of jacobian, and checks) and allows to generate individual constraint and option objects.
- **Constraints** : The constraints class ([`AbstractSOSConstraints.m`](/AbstractSOSConstraints.m)) collects the SOS constraints to describe a SOS problem and generates decision variable. It supports non-negativity constraints for scalars, matrices (positive semi-definiteness), and polynomials (sum-of-squares). Calling the respective solver is facilitated through the `optimize` method of the constraint object (specific constraint implementation may provide additional optimisation methods).
- **Solution** : The solution class ([`AbstractSOSSolution.m`](/AbstractSOSSolution.m)) is solely return by the optimisation method of the constraint object and provides information and results of a sum-of-squares optimisation. The resulting values of the decision variables are accessible through the `subs` method.


### Supported toolbox

To date, `SOSFactory` supports sosopt and SPOT; but any toolbox can be added provided the interface described above (and defined in the abstract super-classes) is implemented.

#### Note on sosopt:
The sosopt constraint class supports quasi-convex optimisation.

#### Note on SPOT:
The SPOT factory / constraint classes support DSOS constraints through different implementations of `AbstractSOSConstrains`.
