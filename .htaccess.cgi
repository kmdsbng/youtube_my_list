DirectoryIndex index.cgi
RewriteEngine On
RewriteBase /youtube_my_list
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*) index.cgi/$1 [L]

#DirectoryIndex index.fcgi
#RewriteEngine On
#RewriteBase /youtube_my_list
#RewriteCond %{REQUEST_FILENAME} !-f
#RewriteCond %{REQUEST_FILENAME} !-d
#RewriteRule ^(.*) index.fcgi/$1 [L]



