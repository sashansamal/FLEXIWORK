import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { api, ApiError } from '../../api';

// Company payments tab: outstanding summary, status filter, pay + PDF download per row.
export default function Payments() {
  const [payments, setPayments] = useState(null);
  const [summary, setSummary] = useState(null);
  const [status, setStatus] = useState('');
  const [downloadingId, setDownloadingId] = useState(null);
  const [err, setErr] = useState(null);

  function load() {
    const q = status ? `?status=${status}` : '';
    api.get(`/api/company/payments${q}`).then(setPayments).catch(() => setPayments([]));
    api.get('/api/company/payments/summary').then(setSummary).catch(() => {});
  }
  useEffect(load, [status]);

  async function download(id) {
    if (downloadingId) return;
    setErr(null); setDownloadingId(id);
    try {
      const blob = await api.get(`/api/company/payments/${id}/receipt`);
      const url = URL.createObjectURL(blob);
      window.open(url, '_blank');
    } catch (e) {
      setErr(e instanceof ApiError ? e.message : 'Failed to download');
    } finally { setDownloadingId(null); }
  }

  const FILTERS = [['', 'All'], ['PENDING', 'Pending'], ['PAID', 'Paid']];

  return (
    <div className="page pay">
      {/* Header */}
      <div className="pay-header">
        <h1 className="pay-title">Payments</h1>
      </div>

      {/* Summary cards */}
      {summary && (
        <div className="pay-summary" style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 16, marginTop: 28 }}>
          <div className="pay-sum-card" style={{ minWidth: 0 }}>
            <div className="pay-sum-label">Pending</div>
            <div className="pay-sum-value">{summary.pendingCount}</div>
          </div>
          <div className="pay-sum-card is-outstanding" style={{ minWidth: 0 }}>
            <div className="pay-sum-label">Outstanding · LKR</div>
            <div className="pay-sum-value">{Number(summary.totalOutstanding).toLocaleString()}</div>
          </div>
          <div className="pay-sum-card" style={{ minWidth: 0 }}>
            <div className="pay-sum-label">Total paid · LKR</div>
            <div className="pay-sum-value">{Number(summary.totalPaid).toLocaleString()}</div>
          </div>
        </div>
      )}

      {err && <div className="form-error mt-16">{err}</div>}

      {/* Filter + record count */}
      <div className="pay-toolbar" style={{ display: 'flex', flexWrap: 'wrap', alignItems: 'center', justifyContent: 'space-between', gap: 16, marginTop: 30 }}>
        <div className="pay-filter" style={{
          display: 'inline-flex', flexDirection: 'row', flexWrap: 'nowrap',
          gap: 4, padding: 4, borderRadius: 9999,
          background: 'var(--surface)', border: '1px solid var(--border)',
        }}>
          {FILTERS.map(([val, label]) => {
            const active = status === val;
            return (
              <button
                key={val}
                className={`pay-filter-btn ${active ? 'is-active' : ''}`}
                onClick={() => setStatus(val)}
                style={{
                  flex: '0 0 auto', width: 'auto', whiteSpace: 'nowrap',
                  border: 'none', cursor: 'pointer', fontFamily: 'inherit',
                  padding: '8px 22px', borderRadius: 9999, fontSize: 14, fontWeight: 700,
                  background: active ? 'var(--primary)' : 'transparent',
                  color: active ? '#fff' : 'var(--text-muted)',
                  transition: 'background .15s, color .15s',
                }}
              >{label}</button>
            );
          })}
        </div>
        <span className="pay-count" style={{ fontSize: 14, fontWeight: 600, color: 'var(--text-muted)' }}>
          {payments ? `${payments.length} record${payments.length === 1 ? '' : 's'}` : ''}
        </span>
      </div>

      {/* List */}
      {!payments ? (
        <div className="skeleton skel-card mt-16" />
      ) : payments.length === 0 ? (
        <div className="pay-empty">
          <div className="pay-empty-icon">Rs</div>
          <div className="pay-empty-title">No payments yet</div>
          <div className="pay-empty-sub">Payments will appear here once jobs are completed.</div>
        </div>
      ) : (
        <div className="pay-list">
          {payments.map((p) => (
            <div key={p.id} className="pay-row">
              <div className="pay-row-main">
                <div className="pay-row-job">{p.jobTitle}</div>
                <div className="pay-row-meta">Receipt {p.receiptNumber}</div>
              </div>
              <div className="pay-row-amount">
                <div className="pay-row-label">Commission · LKR</div>
                <div className="pay-row-value">{Number(p.commissionAmount).toLocaleString()}</div>
              </div>
              <span className={`badge ${p.status}`}>{p.status}</span>
              <div className="pay-row-actions">
                {p.status === 'PENDING' && (
                  <Link className="pay-btn pay-btn-primary" to={`/company/payments/${p.id}/pay`}>Pay</Link>
                )}
                <button className="pay-btn pay-btn-ghost" disabled={downloadingId === p.id} onClick={() => download(p.id)}>
                  {downloadingId === p.id ? 'Downloading…' : p.status === 'PAID' ? 'Receipt' : 'Invoice'}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
