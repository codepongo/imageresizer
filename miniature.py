import sys
import os
def walk(directory):
    files = []
    for dirpath, dirnames, filenames in os.walk(directory):
        for i in xrange(len(filenames)):
            files.append(os.path.join(dirpath, filenames[i]))
    return files

def miniature(directory, files, prefix):
    i = 0
    for f in files:
        print 'ImageResize %s%s%s%02d.jpg -s 30 -i %s ' % (directory, os.sep, prefix, i, f)
        os.popen('ImageResize %s%s%s%02d.jpg -s 30 -i %s ' % (directory, os.sep, prefix, i, f))
        i += 1

if __name__ == '__main__':
    miniature(sys.argv[1], walk(sys.argv[1]), sys.argv[2])
