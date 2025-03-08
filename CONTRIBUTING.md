# Contributing to ChromeOS Linux App Launcher Creator

Thank you for considering contributing to the ChromeOS Linux App Launcher Creator! Here are some guidelines to help you get started.

## How to Contribute

1. **Fork the repository** - Create your own copy of the project on GitHub.

2. **Clone your fork** - Work on your local machine.
   ```
   git clone https://github.com/YOUR_USERNAME/chromeos-linux-app-launcher-creator.git
   ```

3. **Create a branch** - Make your changes in a new branch.
   ```
   git checkout -b feature/my-new-feature
   ```

4. **Make your changes** - Implement your feature or bug fix.

5. **Test your changes** - Make sure your changes work on a Chromebook with Linux enabled.

6. **Commit your changes** - Use clear commit messages.
   ```
   git commit -m "Add support for application XYZ"
   ```

7. **Push to your fork** - Upload your changes to GitHub.
   ```
   git push origin feature/my-new-feature
   ```

8. **Create a Pull Request** - Submit your changes for review.

## Adding Support for a New Application

If you want to add support for a new application, please:

1. Create a new launcher script in the format `appname-launcher.sh`
2. Follow the pattern used by existing launcher scripts
3. Test your script on an actual Chromebook
4. Add the application to the README as an example

## Coding Style

- Use 4 spaces for indentation
- Follow the existing code style
- Add comments for complex operations
- Make sure variables are properly quoted

## Testing

Before submitting your changes, please test them:

1. On a real Chromebook with Linux (Crostini) enabled
2. With multiple desktop environments (if applicable)
3. With different path configurations

## Documentation

Please update any relevant documentation, including:

- README.md for user-facing changes
- Comments in the code for developer-facing changes
- Any Wiki pages (if applicable)

## License

By contributing to this project, you agree that your contributions will be licensed under the project's MIT License. 