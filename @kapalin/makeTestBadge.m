function badge_url = makeTestBadge(results)

badge_url_pass = 'https://img.shields.io/badge/OS-n_pass/n_total-brightgreen.svg';
badge_url_fail = 'https://img.shields.io/badge/OS-n_pass/n_total-red.svg';

if results.n_pass == results.n_total
	badge_url = badge_url_pass;
else
	badge_url = badge_url_fail;
end

badge_url = strrep(badge_url,'OS',results.os_version);
badge_url = strrep(badge_url,'n_pass',mat2str(results.n_pass));
badge_url = strrep(badge_url,'n_total',mat2str(results.n_total));
