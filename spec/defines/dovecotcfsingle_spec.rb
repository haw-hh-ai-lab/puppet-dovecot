require 'spec_helper'

describe 'dovecot::config::dovecotcfsingle', :type => :define do
  let(:facts) { {:operatingsystem => 'Debian', :operatingsystemrelease => '7.1'} }
  let(:title) { 'foo' }
  let(:params) { {:ensure => 'present', :value => 'foo' } }
  it 'should have an augeas resource' do
	should contain_augeas('dovecot /etc/dovecot/dovecot.conf foo')
  end
  describe_augeas 'dovecot /etc/dovecot/dovecot.conf foo', :lens => 'dovecot', :target => '/etc/dovecot/dovecot.conf' do
    it 'foo should exist with value foo' do
      should execute.with_change

      aug_get('foo').should == 'foo' 

      should execute.idempotently
    end
  end
end

describe 'dovecot::config::dovecotcfsingle', :type => :define do
  let(:facts) { {:operatingsystem => 'Debian', :operatingsystemrelease => '7.1'} }
  let(:title) { 'bar' }
  let(:params) { {:ensure => 'absent'} }
  it 'should have an augeas resource' do
	should contain_augeas('dovecot /etc/dovecot/dovecot.conf bar')
  end
  describe_augeas 'dovecot /etc/dovecot/dovecot.conf bar', :lens => 'dovecot', :target => '/etc/dovecot/dovecot.conf' do
    it 'bar should not exist with value foo' do
      should execute.with_change

      aug_get('bar').should == nil

      should execute.idempotently
    end
  end
end

describe 'dovecot::config::dovecotsingle', :tpye => :define do
  let(:facts) { {:operatingsystem => 'Ubuntu', :operatingsystemrelease => '14.04'} }
  let(:title) { 'foo' }
  let(:params) { {:ensure => 'present', :value => 'foo' } }
  
  it 'must not have an augeas lens file' do
      should_not contain_file('/usr/share/augeas/lenses/dist/build.aug')
  end
end

describe 'dovecot::config::dovecotsingle', :tpye => :define do
  let(:facts) { {:operatingsystem => 'Ubuntu', :operatingsystemrelease => '13.10'} }
  let(:title) { 'foo' }
  let(:params) { {:ensure => 'present', :value => 'foo' } }
  
  it 'must have an augeas lens file' do
      should contain_file('/usr/share/augeas/lenses/dist/build.aug')
  end
end

describe 'dovecot::config::dovecotsingle', :tpye => :define do
  let(:facts) { {:operatingsystem => 'Ubuntu', :operatingsystemrelease => '14.10'} }
  let(:title) { 'foo' }
  let(:params) { {:ensure => 'present', :value => 'foo' } }
  
  it 'must not have an augeas lens file' do
      should_not contain_file('/usr/share/augeas/lenses/dist/build.aug')
  end
end
