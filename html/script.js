const hud = document.getElementById('jobHud');
window.addEventListener('message', (e) => {
  const msg = e.data || {};
  if (msg.action === 'showJob') {
    const d = msg.data || {};
    document.getElementById('jTitle').textContent = d.title || 'JOB';
    document.getElementById('jLine').textContent = d.line || '';
    document.getElementById('jPay').textContent = d.pay || '';
    hud.classList.remove('hidden');
  } else if (msg.action === 'hideJob') {
    hud.classList.add('hidden');
  }
});
