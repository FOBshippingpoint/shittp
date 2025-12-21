import "./style.css";
import { highlight } from "@arborium/arborium";

for (const codeEl of document.querySelectorAll("[data-lang]")) {
	highlight(codeEl.dataset.lang, codeEl.textContent.trim()).then((html) => {
		codeEl.innerHTML = html;
	});
}
