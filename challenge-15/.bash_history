git clone https://github.com/example/webapp.git
cd webapp
ls -la
cat README.md
npm install
npm run build
npm test
git log --oneline -10
git checkout -b feature/auth
vim src/auth.js
git add src/auth.js
git commit -m "add jwt auth"
git push origin feature/auth
ls src/
cat src/config.js
vim .env
npm run dev
curl http://localhost:3000/api/health
curl http://localhost:3000/api/users
git status
git diff
npm run lint
vim src/middleware.js
git add -A
git commit -m "add rate limiting middleware"
git log --oneline
cd ..
mkdir backup
cp -r webapp backup/
ls backup/
git pull origin main
git merge feature/auth
npm run test:coverage
cat package.json
grep -r "TODO" src/
find . -name "*.log" -delete
ls -lh
df -h
ps aux | grep node
kill 1234
export NODE_ENV=production
export DATABASE_URL=postgres://localhost:5432/webapp
export SECRET_TOKEN="flag{blast_from_the_past}"
npm run migrate
npm run seed
node src/server.js &
curl http://localhost:3000
curl -X POST http://localhost:3000/api/login -d '{"user":"admin"}'
tail -f logs/app.log
grep "ERROR" logs/app.log
wc -l logs/app.log
cat logs/app.log | grep "200"
git tag v1.0.0
git push origin v1.0.0
git checkout main
git pull
npm version patch
git log --since="1 week ago"
ls -la node_modules/
du -sh node_modules/
cat .gitignore
vim package.json
npm run build
ls dist/
zip -r dist.zip dist/
exit
