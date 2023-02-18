# Coding Guidelines

- How to join the project? Check out [our documentation](https://hackmd.io/bNV8xhVwQxOYnLt9NTRdFw).
- We are using Swiftlint to enforce Swift style and conventions
- We're using [PaintCode Plugin for Sketch](https://www.paintcodeapp.com/sketch) for vector image assets.

## SwiftLint 
If you are using Apple Silicon, you might experience `brew: command not found` error   
That is because `Homebrew` on Apple Silicon installs the binaries into the `/opt/homebrew/bin` folder by default. To instruct Xcode where to find `Homebrew`   
Please create a symbolic link in `/usr/local/bin`
```
$ sudo ln -s /opt/homebrew/bin/brew /usr/local/bin/brew
```

# License

Licensed under the GPLv3: https://www.gnu.org/licenses/gpl-3.0.html

Additional Permissions For Submission to Apple App Store: Provided that you are otherwise in compliance with the GPLv3 for each covered work you convey (including without limitation making the Corresponding Source available in compliance with Section 6 of the GPLv3), Ptt also grants you the additional permission to convey through the Apple App Store non-source executable versions of the Program as incorporated into each applicable covered work as Executable Versions only under the Mozilla Public License version 2.0 (https://www.mozilla.org/en-US/MPL/2.0/).
