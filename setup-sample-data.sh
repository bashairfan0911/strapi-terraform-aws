#!/bin/bash
# Script to create Article content type and sample data in Strapi

echo "Setting up Strapi with sample Article content..."

# Navigate to Strapi project
cd /home/ubuntu/strapi-app/my-strapi-project

# Create Article content type structure
mkdir -p src/api/article/content-types/article
mkdir -p src/api/article/controllers
mkdir -p src/api/article/routes
mkdir -p src/api/article/services

# Create schema
cat > src/api/article/content-types/article/schema.json << 'EOF'
{
  "kind": "collectionType",
  "collectionName": "articles",
  "info": {
    "singularName": "article",
    "pluralName": "articles",
    "displayName": "Article",
    "description": "Sample article content type"
  },
  "options": {
    "draftAndPublish": true
  },
  "pluginOptions": {},
  "attributes": {
    "title": {
      "type": "string",
      "required": true
    },
    "content": {
      "type": "richtext"
    },
    "author": {
      "type": "string"
    },
    "publishedDate": {
      "type": "date"
    }
  }
}
EOF

# Create controller
cat > src/api/article/controllers/article.js << 'EOF'
'use strict';
const { createCoreController } = require('@strapi/strapi').factories;
module.exports = createCoreController('api::article.article');
EOF

# Create service
cat > src/api/article/services/article.js << 'EOF'
'use strict';
const { createCoreService } = require('@strapi/strapi').factories;
module.exports = createCoreService('api::article.article');
EOF

# Create routes
cat > src/api/article/routes/article.js << 'EOF'
'use strict';
const { createCoreRouter } = require('@strapi/strapi').factories;
module.exports = createCoreRouter('api::article.article');
EOF

echo "Content type created. Restarting Strapi..."

# Restart PM2
pm2 restart strapi

echo "Waiting for Strapi to restart (30 seconds)..."
sleep 30

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Go to: http://18.223.140.18:1337/admin"
echo "2. Login to admin panel"
echo "3. Go to Content Manager → Article"
echo "4. Create new articles"
echo "5. Publish them"
echo "6. Go to Settings → Roles → Public → Article"
echo "7. Enable 'find' and 'findOne' permissions"
echo "8. Save"
echo ""
echo "Then test API: http://18.223.140.18:1337/api/articles"
echo ""
