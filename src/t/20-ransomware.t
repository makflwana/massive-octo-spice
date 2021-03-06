use strict;

use Test::More;

BEGIN { 
    use_ok('CIF');
    use_ok('CIF::Smrt');
    use_ok('CIF::Rule');
};

use CIF qw/parse_rules normalize_timestamp/;
my $rule = 'rules/default/ransomware_abuse_ch.yml';

$rule = parse_rules($rule, 'ransomware');

$rule->set_not_before('10000 days ago');
$rule->{'defaults'}->{'remote'} = 'testdata/abuse.ch/ransomware.csv';

my $ret = CIF::Smrt->new({
        rule            => $rule,
        tmp             => '/tmp',
        ignore_journal  => 1,
        not_before      => '2010-01-01',
})->process();

ok($ret && $#{$ret} >= 0,'testing for results for: '.$rule->{'feed'});
ok(@$ret[-1]->{'observable'} eq 'http://hrfgd74nfksjdcnnklnwefvdsf.materdunst.com/', 'testing output...');
ok($#{$ret} == 13);

done_testing();
