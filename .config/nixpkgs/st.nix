{ config, pkgs, ... }:

{ 
    # see nixos.wiki/wiki/St; can fetch config.def.h individually, as well
    home.packages = with pkgs; [
        (st.overrideAttrs (oldAttrs: rec {
            src = fetchurl {
                url = "https://dl.suckless.org/st/st-0.8.4.tar.gz";
                sha256 = "19j66fhckihbg30ypngvqc9bcva47mp379ch5vinasjdxgn3qbfl";
            };
            patches = [
                (fetchpatch {
                    url = "https://st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff";
                    sha256 = "0z2cjwhlhfhs7v8fx16fj9a9qdhrnxwr94kswhgxgphaky0x66i2";
                })
				(fetchpatch {
					url = "https://st.suckless.org/patches/boxdraw/st-boxdraw_v2-0.8.3.diff";
					sha256 = "1jg4z6i2x5fb48d48virb799x1p2h54pywwmpybsdll913s9x7z7";
				})
				(fetchpatch {
					url = "https://st.suckless.org/patches/clipboard/st-clipboard-0.8.3.diff";
					sha256 = "1kv733x69qbk6ng4wfdzr60xy1m02v3arbcsq4v6i65lx5spdcyb";
				})
				(fetchpatch {
					url = "https://st.suckless.org/patches/gruvbox/st-gruvbox-dark-0.8.2.diff";
					sha256 = "14ajygrlz4z3p0w90cbdc7xk2wikhys4m761ci3ln7p16n48qxdz";
				})
				(fetchpatch {
					url = "https://st.suckless.org/patches/hidecursor/st-hidecursor-0.8.3.diff";
					sha256 = "1y7fjin8lrzimh61y0vi04bjpyhi90lxvzwabncdi5sldk9yfgq6";
				})
				(fetchpatch {
					url = "https://st.suckless.org/patches/sync/st-appsync-20200618-b27a383.diff";
					sha256 = "1yxqvrkd6w78j8nnpcx2ndnycj6jazmhmgk5fa3azvd9ggz3nawp";
				})
            ];
			configFile = writeText "config.def.h" (builtins.readFile ./files/st/config.def.h);
            postPatch = ''
                        ${oldAttrs.postPatch}
                        cp ${configFile} config.def.h
                        '';
        }))
    ];
}
