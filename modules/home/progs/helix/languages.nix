{ pkgs }:

{
  language-server = {
    efm = {
      command = "${pkgs.efm-langserver}/bin/efm-langserver";      
      args = [
        "-loglevel" "10" "-logfile" "/tmp/helix.efm.log"
      ];
    };

    gopls = {
      command = "${pkgs.gopls}/bin/gopls";
      buildTags = [
        "-tags=integration_test,dynamic,wireinject"
        "-v"
      ];
      gofumpt = true;
      staticcheck = true;
      verboseOutput = true;
      completeUnimported = true;

      config = {
        analyses = {
          fieldalignment = true;
          nilness = true;
          unusedparams = true;
          unusedwrite = true;
        };

        hints = {
          constantValues = true;
          parameterNames = true;
          assignVariableType = true;
          rangeVariableTypes = true;
          compositeLiteralTypes = true;
          compositeLiteralFields = true;
          functionTypeParameters = true;
        };
      };
    };
  };

  language = [
    {
      name = "go";
      auto-format = true;
      language-servers = [
        {
          name = "efm";
          only-features = [ "diagnostics" ];
        }
        { name = "gopls"; }
      ];
    }
    {
      name = "rust";
      auto-format = true;
      indent = {
        tab-width = 4;
        unit = "\t";
      };
    }
    {
      name = "python";
      auto-format = true;
    }
    {
      name = "toml";
      auto-format = true;
    }
    {
      name = "yaml";
      auto-format = true;
    }
    {
      name = "json";
      auto-format = true;
    }
  ];
}
