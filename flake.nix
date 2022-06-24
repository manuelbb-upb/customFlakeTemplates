

{
  description = "Personal Flake Templates";

  outputs = { self }: {

    templates = {
      python-poetry2nix = {
        description = "A Python project built with poetry2nix";
        path = ./python_poetry2nix2nix;
      };
    };

    templates.default = templates.python-poetry2nix;

  };
}
