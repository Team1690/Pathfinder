package utils

import (
	"encoding/csv"
	"os"

	"github.com/jszwec/csvutil"
	"golang.org/x/xerrors"
)

func SaveCSV(filePath string, v interface{}) error {
	f, err := os.Create(filePath)
	if err != nil {
		return xerrors.Errorf("error creating file [%s]: %w", filePath, err)
	}
	defer f.Close()

	csvReader := csv.NewWriter(f)
	defer csvReader.Flush()

	enc := csvutil.NewEncoder(csvReader)

	if err = enc.Encode(v); err != nil {
		return xerrors.Errorf("error encoding file [%s]: %w", filePath, err)
	}

	return nil
}
