require 'spec_helper'

describe 'dovecot::config::dovecotcfmulti', :type => :define do
  let(:facts) { {:operatingsystem => 'Debian', :operatingsystemrelease => '7.1'} }
  let(:title) { 'multi' }
  let(:params) { {:changes => [ 'set foo \'bar\'', 'rm bar' ], } }
  it 'should have an augeas resource' do
	should contain_augeas('dovecot /etc/dovecot/dovecot.conf multi')
  end
  describe_augeas 'dovecot /etc/dovecot/dovecot.conf multi', :lens => 'dovecot', :target => '/etc/dovecot/dovecot.conf' do
    it 'foo should exist with value foo and bar should not exist' do
      should execute.with_change

      aug_get('foo').should == 'bar' 
      aug_get('bar').should == nil

      should execute.idempotently
    end
  end
end

describe 'dovecot::config::dovecotmulti', :tpye => :define do
  let(:facts) { {:operatingsystem => 'Ubuntu', :operatingsystemrelease => '14.04'} }
  let(:title) { 'foo' }
  let(:params) { {:changes => [ 'set foo \'bar\'', 'rm bar' ], } }
  
  it 'must not have an augeas lens file' do
      should not contain_file('/usr/share/augeas/lenses/dist/build.aug')
  end
end

describe 'dovecot::config::dovecotmulti', :tpye => :define do
  let(:facts) { {:operatingsystem => 'Ubuntu', :operatingsystemrelease => '13.10'} }
  let(:title) { 'bar' }
  let(:params) { {:changes => [ 'set foo \'bar\'', 'rm bar' ], } }
  
  it 'must not have an augeas lens file' do
      should contain_file('/usr/share/augeas/lenses/dist/build.aug')
  end
end

describe 'dovecot::config::dovecotmulti', :tpye => :define do
  let(:facts) { {:operatingsystem => 'Ubuntu', :operatingsystemrelease => '14.10'} }
  let(:title) { 'foo' }
  let(:params) { {:changes => [ 'set foo \'bar\'', 'rm bar' ], } }
  
  it 'must not have an augeas lens file' do
      should contain_file('/usr/share/augeas/lenses/dist/build.aug')
  end
end
