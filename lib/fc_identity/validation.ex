defmodule FCIdentity.Validation do

  def validate(struct, settings) do
    case Vex.validate(struct, settings) do
      {:error, errors} ->
        {:error, {:validation_failed, normalize_errors(errors, settings)}}

      other ->
        other
    end
  end

  def errors(struct, settings) do
    struct
    |> Vex.errors(settings)
    |> normalize_errors(settings)
  end

  def errors(struct) do
    settings = struct.__struct__.__vex_validations__

    struct
    |> Vex.errors()
    |> normalize_errors(settings)
  end

  defp normalize_errors(errors, settings) do
    Enum.reduce(errors, [], fn(error, acc) ->
      acc ++ [normalize_error(settings, error)]
    end)
  end

  defp normalize_error(settings, {:error, key, :length, _}) do
    info = Keyword.take(settings[key][:length], [:min, :max])
    {:error, key, {:invalid_length, info}}
  end

  defp normalize_error(_, {:error, key, :acceptance, _}) do
    {:error, key, :must_be_true}
  end

  defp normalize_error(_, {:error, key, :presence, _}) do
    {:error, key, :required}
  end

  defp normalize_error(_, {:error, key, :format, _}) do
    {:error, key, :invalid_format}
  end
end