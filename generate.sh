#!/bin/bash

# Run build_runner to generate code
echo "Running build_runner to generate code..."
dart run build_runner build --delete-conflicting-outputs

echo "Code generation complete!"