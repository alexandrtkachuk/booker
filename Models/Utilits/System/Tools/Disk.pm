package System::Tools::Disk;

use strict;
use vars qw(@ISA);
use System::Tools::Config;
use System::Tools::Primitive;
@ISA = qw(System::Tools::Primitive);

my $self;

sub instance($);
sub loadFileAsString($$);
sub loadFileAsArray($$);
sub saveStringInNewFile($$$);
sub saveArrayInNewFile($$$);
sub updateFileFromString($$$);
sub updateFileFromArray($$$);
sub copyFileToNewFile($$$);
sub moveFile($$$);
sub removeFile($$);
sub getFilesListFromDir($$);

sub getDirsListFromDir($$);
sub makeNewDir($$);
sub makeNewDirParent($$);
sub removeDir($$);
sub copyDirToDir($$$);
sub renameDir($$$);
sub moveDirToDir($$$);


my $isFileExists = sub($$) {

	my ($self, $file) = @_;

	if (-e $file)
	{
		$self->logIt(__LINE__, "File exists [$file].");
		return 1;
	}

	$self->logIt(__LINE__, "ERROR: [$file] isn't exists!");
	return undef;
};

my $isDir = sub($$) {

	my ($self, $dir) = @_;

	if (-d $dir)
	{
		$self->logIt(__LINE__, "$dir is directory.");
		return 1;
	}

	$self->logIt(__LINE__, "ERROR: [$dir] isn't directory!");
	return undef;
};

my $isFile = sub($$) {

	my ($self, $file) = @_;

	if (-f $file)
	{
		$self->logIt(__LINE__, "[$file] is a plain file.");
		return 1;
	}

	$self->logIt(__LINE__, "ERROR: [$file] isn't a plain file!");
	return undef;
};

my $isReadable = sub($$) {

	my ($self, $file) = @_;

	if (-r $file)
	{
		$self->logIt(__LINE__, "File is readable [$file].");
		return 1;
	}

	$self->logIt(__LINE__, "ERROR: [$file] isn't readable!");
	return undef;

};

my $isWritable = sub($$) {

	my ($self, $file) = @_;

	if (-w $file)
	{
		$self->logIt(__LINE__, "File is writable [$file].");
		return 1;
	}

	$self->logIt(__LINE__, "ERROR: [$file] isn't writable!");
	return undef;

};

my $isExecutable = sub($$) {

	my ($self, $file) = @_;

	if (-x $file)
	{
		$self->logIt(__LINE__, "File is executable [$file].");
		return 1;
	}

	$self->logIt(__LINE__, "ERROR: [$file] isn't executable!");
	return undef;
};

my $isFileAllowToRead = sub($$) {

	my ($self, $file) = @_;

	(!$self->$isFileExists($file) ||
	!$self->$isFile($file) ||
	!$self->$isReadable($file)) &&
	return undef;

	return 1;
};

my $isFileAllowToWrite = sub($$) {

	my ($self, $file) = @_;

	(!$self->$isFileExists($file) ||
	!$self->$isFile($file) ||
	!$self->$isWritable($file)) &&
	return undef;

	return 1;
};

my $isFileAllowToExecute = sub($$) {

	my ($self, $file) = @_;

	(!$self->$isFileExists($file) ||
	!$self->$isFile($file) ||
	!$self->$isExecutable($file)) &&
	return undef;

	return 1;
};

my $isDirAllowToRead = sub($$) {

	my ($self, $dir) = @_;

	(!$self->$isFileExists($dir) ||
	!$self->$isDir($dir) ||
	!$self->$isReadable($dir)) &&
	return undef;

	return 1;
};

my $isDirAllowToWrite = sub($$) {

	my ($self, $dir) = @_;

	(!$self->$isFileExists($dir) ||
	!$self->$isDir($dir) ||
	!$self->$isWritable($dir)) &&
	return undef;

	return 1;
};

my $isDirAllowToExecute = sub($$) {

	my ($self, $dir) = @_;

	(!$self->$isFileExists($dir) ||
	!$self->$isDir($dir) ||
	!$self->$isExecutable($dir)) &&
	return undef;

	return 1;
};

my $getPath = sub($$) {

	my ($self, $file) = @_;

	my @path = split('/', $file);
	pop @path;
	return join('/', @path);
};

my $openFileStream = sub($$;$) {

	my ($self, $file, $direction) = @_;

	$direction !~ /^(<)|(>)|(>>)$/ &&
	return undef;

	my $fh;

	if (open $fh, "$direction $file")
	{
		binmode($fh);
		$self->logIt(__LINE__, "File stream is open.");
		return $fh;
	}

	$self->logIt(__LINE__, "ERROR: can't open filestream"
		. " for [$file]!\n $!");
	return undef;
};

my $getDirContent = sub($$) {

	my ($self, $dir) = @_;

	(!$self->$isDirAllowToRead($dir) ||
	!$self->$isDirAllowToExecute($dir)) &&
	return undef;

	my $dh = undef;

	!opendir($dh, $dir) &&
	$self->logIt(__LINE__, "ERROR: can't open dirstream"
		. " for [$dir]!\n $!") &&
	return undef;

	my @content = ();

	while (readdir $dh)
	{
		push @content, $_;
	}

	closedir $dh;
	$self->logIt(__LINE__, "Directory content gotten.");
	return \@content;
};

sub instance($)
{
	my $class = ref($_[0]) || $_[0];

	unless ($self)
	{
		$self = bless {}, $class;
		$self->logIt(__LINE__, ref($self) . " instance redy to use.");
	}

	return $self;
}

sub loadFileAsString($$)
{
	my ($self, $file) = @_;

	my $destinationDir = $self->$getPath($file);

	(!$self->$isDirAllowToRead($destinationDir) ||
	!$self->$isFileAllowToRead($file)) &&
	return undef;

	my $fh = $self->$openFileStream($file, '<');

	!$fh && return undef;

	local $/ = undef;
	my $content = <$fh>;
	close $fh;
	return $content;
}

sub loadFileAsArray($$)
{
	my ($self, $file) = @_;

	my $destinationDir = $self->$getPath($file);

	(!$self->$isDirAllowToRead($destinationDir) ||
	!$self->$isFileAllowToRead($file)) &&
	return undef;

	my $fh = $self->$openFileStream($file, '<');

	!$fh && return undef;

	my @content = ();

	while (<$fh>)
	{
		push @content, $_;
	}

	close $fh;
	return \@content;
}

sub saveStringInNewFile($$$)
{
	my ($self, $file, $contentString) = @_;

	my $destinationDir = $self->$getPath($file);
	
	(!$self->$isDirAllowToWrite($destinationDir) ||
	$self->$isFileExists($file)) &&
	return undef;

	my $fh = $self->$openFileStream($file, '>');

	!$fh && return undef;

	local $| = 1;
	local $\ = undef;
	print $fh $contentString;
	close $fh;
	return 1;
}

sub saveArrayInNewFile($$$)
{
	my ($self, $file, $contentArrRef) = @_;

	my $destinationDir = $self->$getPath($file);

	(!$self->$isDirAllowToWrite($destinationDir) ||
	$self->$isFileExists($file)) &&
	return undef;

	my $fh = $self->$openFileStream($file, '>');

	!$fh && return undef;

	local $| = 1;

	foreach my $string (@$contentArrRef)
	{
		print $fh $string;
	}

	close $fh;
	return 1;
}

sub updateFileFromString($$$)
{
	my ($self, $file, $contentString) = @_;

	my $destinationDir = $self->$getPath($file);

	(!$self->$isDirAllowToWrite($destinationDir) ||
	!$self->$isDirAllowToRead($destinationDir) ||
	!$self->$isFileAllowToWrite($file) ||
	!$self->$isFileAllowToRead($file)) &&
	return undef;

	my $fh = $self->$openFileStream($file, '>>');

	!$fh && return undef;

	local $| = 1;
	local $\ = undef;
	print $fh $contentString;
	close $fh;
	return 1;
}

sub updateFileFromArray($$$)
{
	my ($self, $file, $contentArrRef) = @_;

	my $destinationDir = $self->$getPath($file);

	(!$self->$isDirAllowToWrite($destinationDir) ||
	!$self->$isDirAllowToRead($destinationDir) ||
	!$self->$isFileAllowToWrite($file) ||
	!$self->$isFileAllowToRead($file)) &&
	return undef;

	my $fh = $self->$openFileStream($file, '>>');

	!$fh && return undef;

	local $| = 1;

	foreach my $string (@$contentArrRef)
	{
		print $fh $string;
	}

	close $fh;
	return 1;
}

sub copyFileToNewFile($$$)
{
	my ($self, $sourceFile, $destinationFile) = @_;

	my $sourceDir = $self->$getPath($sourceFile);
	my $destinationDir = $self->$getPath($destinationFile);

	$self->$isDirAllowToRead($sourceDir) &&
	$self->$isFileAllowToRead($sourceFile) &&
	$self->$isDirAllowToWrite($destinationFile) &&
	!$self->$isFileExists($destinationFile) &&
	! ! system("cp $sourceFile $destinationFile") &&
	$self->logIt(__LINE__, "File [$sourceFile] copied"
		. " to [$destinationFile]") &&
	return 1;

	$self->logIt(__LINE__, "ERROR: can't copi [$sourceFile]"
		. " to [$destinationFile]\n$!");
	return undef;
}

sub moveFile($$$)
{
	my ($self, $sourceFile, $destinationFile) = @_;

	my $sourceDir = $self->$getPath($sourceFile);
	my $destinationDir = $self->$getPath($destinationFile);

	$self->$isDirAllowToRead($sourceDir) &&
	$self->$isDirAllowToWrite($sourceDir) &&
	$self->$isDirAllowToExecute($sourceDir) &&
	$self->$isDirAllowToRead($destinationDir) &&
	$self->$isDirAllowToWrite($destinationDir) &&
	$self->$isDirAllowToExecute($destinationDir) &&
	! ! system("mv $sourceFile $destinationFile") &&
	$self->logIt(__LINE__, "File [$sourceFile] moved"
		. " to [$destinationFile]") &&
        return 1;

        $self->logIt(__LINE__, "ERROR: can't move [$sourceFile]"
		. " to [$destinationFile]!\n $!");
        return undef;
}

sub removeFile($$)
{
	my ($self, $file) = @_;

	$self->$isFileAllowToWrite($file) &&
	! ! system("rm $file") &&
	$self->logIt(__LINE__, "File [$file] removed.") &&
	return 1;

	$self->logIt(__LINE__, "ERROR: can't remove [$file] file!\n $!");
	return undef;
}

sub getFilesListFromDir($$)
{
	my ($self, $dir) = @_;

	my $content = $self->$getDirContent($dir);

	!$content &&
	return undef;

	my @files = ();

	foreach my $item (@$content)
	{
		push @files, $item if ($self->$isFile($item))
	}

	return \@files;
}

sub getDirsListFromDir($$)
{
	my ($self, $dir) = @_;

	my $content = $self->$getDirContent($dir);

	!$content &&
	return undef;

	my @dirs = ();

	foreach my $item (@$content)
	{
		next if ($item =~ /^(.){1,2}$/);
		push @dirs, $item if ($self->$isDir($item))
	}

	return \@dirs;
}

sub makeNewDir($$)
{
	my ($self, $dir) = @_;

	$self->$isFileExists($dir) &&
	$self->$isDir($dir) &&
	$self->logIt(__LINE__, "ERROR: requested dir [$dir]"
		. " is alredy exists!") &&
	return undef;

	my $topDir = $self->$getPath($dir);

	$self->$isDirAllowToWrite($topDir) &&
	$self->$isDirAllowToExecute($topDir) &&
	! ! system("mkdir $dir") &&
	$self->logIt(__LINE__, "Dir [$dir]"
		. " maked successfully.") &&
	return 1;

	$self->logIt(__LINE__, "ERROR: can't make requested dir [$dir]!\n$!");
	return undef;
}

sub makeNewDirParent($$)
{
	my ($self, $dir) = @_;

	$self->$isFileExists($dir) &&
	$self->$isDir($dir) &&
	$self->logIt(__LINE__, "ERROR: requested dir [$dir]"
		. " is alredy exists!") &&
	return undef;

	my $topDir = $self->$getPath($dir);

	while ($topDir)
	{
		$self->$isFileExists($topDir) &&
		$self->$isDir($dir) &&
		($topDir = $self->$getPath($dir)) &&
		next;

		$self->$isDirAllowToWrite($topDir) &&
		$self->$isDirAllowToExecute($topDir) &&
		! ! system("mkdir -p $dir") &&
		$self->logIt(__LINE__, "Dirs [$dir]"
			. " maked successfully.") &&
		return 1;

		last;
	}

	$self->logIt(__LINE__, "ERROR: can't make requested dir [$dir]!\n$!");
	return undef;
}

sub removeDir($$)
{
	my ($self, $dir) = @_;

	my $topDir = $self->$getPath($dir);

	$self->$isDirAllowToWrite($topDir) &&
	$self->$isDirAllowToRead($topDir) &&
	$self->$isDirAllowToExecute($topDir) &&
	$self->$isDirAllowToWrite($dir) &&
	$self->$isDirAllowToRead($dir) &&
	$self->$isDirAllowToExecute($dir) &&
	! ! system("rm -r $dir") &&
	$self->logIt(__LINE__, "[$dir] deleted successfully.") &&
	return 1;

	$self->logIt(__LINE__, "ERROR: can't deleterequested dir [$dir]!\n$!");
	return undef;
}

sub copyDirToDir($$$)
{
	my ($self, $sourceDir, $destinationDir) = @_;

	
}

sub renameDir($$$)
{
	my ($self, $sourceDir, $newDirName) = @_;
}

sub moveDirToDir($$$)
{
	my ($self, $sourceDir, $destinationDir) = @_;
}

1;
