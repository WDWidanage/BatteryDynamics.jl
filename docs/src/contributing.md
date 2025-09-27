# Contributing

We welcome contributions to BatteryDynamics.jl! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/BatteryDynamics.jl.git
   cd BatteryDynamics.jl
   ```

3. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

1. Activate the package in development mode:
   ```julia
   using Pkg
   Pkg.develop("BatteryDynamics")
   ```

2. Install dependencies:
   ```julia
   Pkg.instantiate()
   ```

3. Run tests to ensure everything works:
   ```julia
   Pkg.test("BatteryDynamics")
   ```

## Making Changes

### Code Style

- Follow Julia style guidelines
- Use meaningful variable and function names
- Add docstrings to all public functions
- Include type annotations where helpful

### Documentation

- Update documentation for any new features
- Add examples to docstrings
- Update the README if needed
- Ensure all public functions are documented

### Testing

- Add tests for new functionality
- Ensure all tests pass before submitting
- Test with different Julia versions if possible

## Submitting Changes

1. Commit your changes:
   ```bash
   git add .
   git commit -m "Add feature: brief description"
   ```

2. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

3. Create a Pull Request on GitHub

## Pull Request Guidelines

### Before Submitting

- [ ] All tests pass
- [ ] Documentation is updated
- [ ] Code follows style guidelines
- [ ] New features have tests
- [ ] Commit messages are clear and descriptive

### Pull Request Description

Include:
- Description of changes
- Motivation for changes
- Any breaking changes
- Tests added/updated
- Documentation updates

## Issue Reporting

When reporting issues, please include:

1. Julia version
2. Operating system
3. Steps to reproduce
4. Expected vs actual behavior
5. Any error messages

## Development Guidelines

### Adding New Functions

1. Add the function to the appropriate module
2. Include comprehensive docstring with:
   - Function description
   - Arguments with types
   - Return value description
   - Examples
   - Any exceptions thrown

3. Export the function in the main module if it should be public

4. Add tests for the function

### Modifying Existing Functions

1. Ensure backward compatibility when possible
2. Update docstrings if behavior changes
3. Update tests if needed
4. Consider deprecation warnings for breaking changes

### Adding Dependencies

1. Discuss major new dependencies in an issue first
2. Add to `Project.toml` with appropriate version constraints
3. Update `Manifest.toml`
4. Update documentation

## Code Review Process

1. All submissions require review
2. Reviewers will check:
   - Code quality and style
   - Test coverage
   - Documentation completeness
   - Performance implications

3. Address review comments promptly
4. Keep PRs focused and reasonably sized

## Release Process

Releases are managed by maintainers. When your PR is merged:

1. Version bumping is handled automatically
2. Documentation is deployed automatically
3. Package registration happens via JuliaRegistrator

## Getting Help

- Open an issue for questions
- Check existing issues and discussions
- Join the Julia Slack #batteries channel for general Julia help

## License

By contributing to BatteryDynamics.jl, you agree that your contributions will be licensed under the same license as the project (MIT License).
