#!/bin/sh
set -e

export JRUBY_VERSION=9.4.8.0

if ! which java
then
    echo "java must be in your PATH: Install Java" >&2
    exit 1
fi
if ! which mvn
then
    echo "mvn must be in your PATH: Install Apache Maven" >&2
    exit 1
fi

MAVEN_REPOSITORY=`mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout`
mvn -Dmdep.outputFile=script/.classpath.txt dependency:build-classpath
JRUBY_JAR=$MAVEN_REPOSITORY/org/jruby/jruby-complete/${JRUBY_VERSION}/jruby-complete-${JRUBY_VERSION}.jar

rm -f script/.jruby
cat >script/.jruby <<__EOL
#!/bin/sh
java -jar $JRUBY_JAR "\$@"
__EOL
chmod a+x script/.jruby
