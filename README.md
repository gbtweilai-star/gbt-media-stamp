# media_stamp

**One capability bit from GBT V8, packaged standalone.** No. 332 of 341,
`video` domain (Video).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 音视频**钢印**（作品出处）：把署名写进**容器元数据**（title/artist/album/comment/description）并用 ffprobe **回读校验**。op=status/tags/verify 为**读类直连**（status 报可打类型；tags 现读一件；verify 逐件报「带/不带钢印」**不报合计**）；stamp 为**写类**（过 filesystem_write 门；写面自收窄到 projects/ · outputs/ · .scratch/）。由来：主人 2026-10-09 问「元数据给她接入了吗」——当时只是 media_run 的内部维度、不能单独点名；现补齐三处（能力表 + api 分派 + 门作用域）。文本页钢印仍走 signature。

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-media-stamp.git
cd gbt-media-stamp
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_media_stamp info                  # capability card
python -m gbt_media_stamp spec --json           # machine-readable contract
python -m gbt_media_stamp check --payload '{}'
python -m gbt_media_stamp run   --payload '{}'
```

Real `info` output from this machine:

```text
media_stamp  (video)  v1.0.0
----------------------------------------
音视频**钢印**（作品出处）：把署名写进**容器元数据**（title/artist/album/comment/description）并用 ffprobe **回读校验**。op=status/tags/verify 为**读类直连**（status 报可打类型；tags 现读一件；verify 逐件报「带/不带钢印」**不报合计**）；stamp 为**写类**（过 filesystem_write 门；写面自收窄到 projects/ · outputs/ · .scratch/）。由来：主人 2026-10-09 问「元数据给她接入了吗」——当时只是 media_run 的内部维度、不能单独点名；现补齐三处（能力表 + api 分派 + 门作用域）。文本页钢印仍走 signature。

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : title, artist, album, comment, description
```

Wire a real implementation:

```python
from gbt_media_stamp import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（5 个）**：`title`、`artist`、`album`、`comment`、`description`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `media_stamp` |
| domain | `video` |
| handler | `media_stamp` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [video/media_stamp](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/video/media_stamp.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
