DECLARE
  l_num NUMBER;
BEGIN
  Pck_Escala_Util.Setloggeduser('WFM');

SELECT
	count(1)
	INTO l_num
FROM
	(
		SELECT
			D_UNIDADE_LISTA_T.*,
			COUNT( c.codigo ) QTDE_COLAB
		FROM
			(
				SELECT
					D_UNIDADE_LISTA_T.*,
					ROWNUM REGISTRO,
					COUNT( 1 ) OVER() TOTAL_REGISTROS
				FROM
					D_UNIDADE_LISTA_T
			) D_UNIDADE_LISTA_T,
			esc_colaborador c,
			esc_grupo g,
			esc_secao s
		WHERE
			D_UNIDADE_LISTA_T.CODIGO = s.FK_UNIDADE(+)
			AND s.codigo = g.fk_secao(+)
			AND g.codigo = c.fk_grupo(+)
			AND(
				c.data_demissao IS NULL
				OR c.data_demissao >= SYSDATE
			)
		GROUP BY
			D_UNIDADE_LISTA_T.CODIGO,
			D_UNIDADE_LISTA_T.NOME,
			D_UNIDADE_LISTA_T.FK_LOGOTIPO,
			D_UNIDADE_LISTA_T.ENDERECO,
			D_UNIDADE_LISTA_T.TXT_HORARIO,
			D_UNIDADE_LISTA_T.INTEGRA_EXTERNO,
			REGISTRO,
			TOTAL_REGISTROS
	) D_UNIDADE_LISTA_T
ORDER BY
	NOME ASC;
	
dbms_output.put_line('NUM: '||l_num);
END;