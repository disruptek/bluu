
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Container Registry
## version: 2019-07-15-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Metadata API definition for the Azure Container Registry runtime
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "containerregistry"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetAcrRepositories_573879 = ref object of OpenApiRestCall_573657
proc url_GetAcrRepositories_573881(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAcrRepositories_573880(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List repositories
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   last: JString
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: JInt
  ##    : query parameter for max number of items
  section = newJObject()
  var valid_574040 = query.getOrDefault("last")
  valid_574040 = validateParameter(valid_574040, JString, required = false,
                                 default = nil)
  if valid_574040 != nil:
    section.add "last", valid_574040
  var valid_574041 = query.getOrDefault("n")
  valid_574041 = validateParameter(valid_574041, JInt, required = false, default = nil)
  if valid_574041 != nil:
    section.add "n", valid_574041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574064: Call_GetAcrRepositories_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List repositories
  ## 
  let valid = call_574064.validator(path, query, header, formData, body)
  let scheme = call_574064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574064.url(scheme.get, call_574064.host, call_574064.base,
                         call_574064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574064, url, valid)

proc call*(call_574135: Call_GetAcrRepositories_573879; last: string = ""; n: int = 0): Recallable =
  ## getAcrRepositories
  ## List repositories
  ##   last: string
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: int
  ##    : query parameter for max number of items
  var query_574136 = newJObject()
  add(query_574136, "last", newJString(last))
  add(query_574136, "n", newJInt(n))
  result = call_574135.call(nil, query_574136, nil, nil, nil)

var getAcrRepositories* = Call_GetAcrRepositories_573879(
    name: "getAcrRepositories", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/_catalog", validator: validate_GetAcrRepositories_573880,
    base: "", url: url_GetAcrRepositories_573881, schemes: {Scheme.Https})
type
  Call_GetAcrRepositoryAttributes_574176 = ref object of OpenApiRestCall_573657
proc url_GetAcrRepositoryAttributes_574178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetAcrRepositoryAttributes_574177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get repository attributes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574193 = path.getOrDefault("name")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "name", valid_574193
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574194: Call_GetAcrRepositoryAttributes_574176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get repository attributes
  ## 
  let valid = call_574194.validator(path, query, header, formData, body)
  let scheme = call_574194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574194.url(scheme.get, call_574194.host, call_574194.base,
                         call_574194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574194, url, valid)

proc call*(call_574195: Call_GetAcrRepositoryAttributes_574176; name: string): Recallable =
  ## getAcrRepositoryAttributes
  ## Get repository attributes
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  var path_574196 = newJObject()
  add(path_574196, "name", newJString(name))
  result = call_574195.call(path_574196, nil, nil, nil, nil)

var getAcrRepositoryAttributes* = Call_GetAcrRepositoryAttributes_574176(
    name: "getAcrRepositoryAttributes", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/acr/v1/{name}",
    validator: validate_GetAcrRepositoryAttributes_574177, base: "",
    url: url_GetAcrRepositoryAttributes_574178, schemes: {Scheme.Https})
type
  Call_UpdateAcrRepositoryAttributes_574204 = ref object of OpenApiRestCall_573657
proc url_UpdateAcrRepositoryAttributes_574206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateAcrRepositoryAttributes_574205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the attribute identified by `name` where `reference` is the name of the repository.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574224 = path.getOrDefault("name")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "name", valid_574224
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   value: JObject
  ##        : Repository attribute value
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574226: Call_UpdateAcrRepositoryAttributes_574204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the attribute identified by `name` where `reference` is the name of the repository.
  ## 
  let valid = call_574226.validator(path, query, header, formData, body)
  let scheme = call_574226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574226.url(scheme.get, call_574226.host, call_574226.base,
                         call_574226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574226, url, valid)

proc call*(call_574227: Call_UpdateAcrRepositoryAttributes_574204; name: string;
          value: JsonNode = nil): Recallable =
  ## updateAcrRepositoryAttributes
  ## Update the attribute identified by `name` where `reference` is the name of the repository.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   value: JObject
  ##        : Repository attribute value
  var path_574228 = newJObject()
  var body_574229 = newJObject()
  add(path_574228, "name", newJString(name))
  if value != nil:
    body_574229 = value
  result = call_574227.call(path_574228, nil, nil, nil, body_574229)

var updateAcrRepositoryAttributes* = Call_UpdateAcrRepositoryAttributes_574204(
    name: "updateAcrRepositoryAttributes", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/acr/v1/{name}",
    validator: validate_UpdateAcrRepositoryAttributes_574205, base: "",
    url: url_UpdateAcrRepositoryAttributes_574206, schemes: {Scheme.Https})
type
  Call_DeleteAcrRepository_574197 = ref object of OpenApiRestCall_573657
proc url_DeleteAcrRepository_574199(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteAcrRepository_574198(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete the repository identified by `name`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574200 = path.getOrDefault("name")
  valid_574200 = validateParameter(valid_574200, JString, required = true,
                                 default = nil)
  if valid_574200 != nil:
    section.add "name", valid_574200
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574201: Call_DeleteAcrRepository_574197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the repository identified by `name`
  ## 
  let valid = call_574201.validator(path, query, header, formData, body)
  let scheme = call_574201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574201.url(scheme.get, call_574201.host, call_574201.base,
                         call_574201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574201, url, valid)

proc call*(call_574202: Call_DeleteAcrRepository_574197; name: string): Recallable =
  ## deleteAcrRepository
  ## Delete the repository identified by `name`
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  var path_574203 = newJObject()
  add(path_574203, "name", newJString(name))
  result = call_574202.call(path_574203, nil, nil, nil, nil)

var deleteAcrRepository* = Call_DeleteAcrRepository_574197(
    name: "deleteAcrRepository", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/acr/v1/{name}", validator: validate_DeleteAcrRepository_574198,
    base: "", url: url_DeleteAcrRepository_574199, schemes: {Scheme.Https})
type
  Call_GetAcrManifests_574230 = ref object of OpenApiRestCall_573657
proc url_GetAcrManifests_574232(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/_manifests")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetAcrManifests_574231(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List manifests of a repository
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574233 = path.getOrDefault("name")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "name", valid_574233
  result.add "path", section
  ## parameters in `query` object:
  ##   orderby: JString
  ##          : orderby query parameter
  ##   last: JString
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: JInt
  ##    : query parameter for max number of items
  section = newJObject()
  var valid_574234 = query.getOrDefault("orderby")
  valid_574234 = validateParameter(valid_574234, JString, required = false,
                                 default = nil)
  if valid_574234 != nil:
    section.add "orderby", valid_574234
  var valid_574235 = query.getOrDefault("last")
  valid_574235 = validateParameter(valid_574235, JString, required = false,
                                 default = nil)
  if valid_574235 != nil:
    section.add "last", valid_574235
  var valid_574236 = query.getOrDefault("n")
  valid_574236 = validateParameter(valid_574236, JInt, required = false, default = nil)
  if valid_574236 != nil:
    section.add "n", valid_574236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574237: Call_GetAcrManifests_574230; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List manifests of a repository
  ## 
  let valid = call_574237.validator(path, query, header, formData, body)
  let scheme = call_574237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574237.url(scheme.get, call_574237.host, call_574237.base,
                         call_574237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574237, url, valid)

proc call*(call_574238: Call_GetAcrManifests_574230; name: string;
          orderby: string = ""; last: string = ""; n: int = 0): Recallable =
  ## getAcrManifests
  ## List manifests of a repository
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   orderby: string
  ##          : orderby query parameter
  ##   last: string
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: int
  ##    : query parameter for max number of items
  var path_574239 = newJObject()
  var query_574240 = newJObject()
  add(path_574239, "name", newJString(name))
  add(query_574240, "orderby", newJString(orderby))
  add(query_574240, "last", newJString(last))
  add(query_574240, "n", newJInt(n))
  result = call_574238.call(path_574239, query_574240, nil, nil, nil)

var getAcrManifests* = Call_GetAcrManifests_574230(name: "getAcrManifests",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}/_manifests", validator: validate_GetAcrManifests_574231,
    base: "", url: url_GetAcrManifests_574232, schemes: {Scheme.Https})
type
  Call_GetAcrManifestAttributes_574241 = ref object of OpenApiRestCall_573657
proc url_GetAcrManifestAttributes_574243(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "reference" in path, "`reference` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/_manifests/"),
               (kind: VariableSegment, value: "reference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetAcrManifestAttributes_574242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get manifest attributes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : A tag or a digest, pointing to a specific image
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574244 = path.getOrDefault("name")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "name", valid_574244
  var valid_574245 = path.getOrDefault("reference")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "reference", valid_574245
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574246: Call_GetAcrManifestAttributes_574241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get manifest attributes
  ## 
  let valid = call_574246.validator(path, query, header, formData, body)
  let scheme = call_574246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574246.url(scheme.get, call_574246.host, call_574246.base,
                         call_574246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574246, url, valid)

proc call*(call_574247: Call_GetAcrManifestAttributes_574241; name: string;
          reference: string): Recallable =
  ## getAcrManifestAttributes
  ## Get manifest attributes
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_574248 = newJObject()
  add(path_574248, "name", newJString(name))
  add(path_574248, "reference", newJString(reference))
  result = call_574247.call(path_574248, nil, nil, nil, nil)

var getAcrManifestAttributes* = Call_GetAcrManifestAttributes_574241(
    name: "getAcrManifestAttributes", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}/_manifests/{reference}",
    validator: validate_GetAcrManifestAttributes_574242, base: "",
    url: url_GetAcrManifestAttributes_574243, schemes: {Scheme.Https})
type
  Call_UpdateAcrManifestAttributes_574249 = ref object of OpenApiRestCall_573657
proc url_UpdateAcrManifestAttributes_574251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "reference" in path, "`reference` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/_manifests/"),
               (kind: VariableSegment, value: "reference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateAcrManifestAttributes_574250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update attributes of a manifest
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : A tag or a digest, pointing to a specific image
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574252 = path.getOrDefault("name")
  valid_574252 = validateParameter(valid_574252, JString, required = true,
                                 default = nil)
  if valid_574252 != nil:
    section.add "name", valid_574252
  var valid_574253 = path.getOrDefault("reference")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "reference", valid_574253
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   value: JObject
  ##        : Repository attribute value
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574255: Call_UpdateAcrManifestAttributes_574249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update attributes of a manifest
  ## 
  let valid = call_574255.validator(path, query, header, formData, body)
  let scheme = call_574255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574255.url(scheme.get, call_574255.host, call_574255.base,
                         call_574255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574255, url, valid)

proc call*(call_574256: Call_UpdateAcrManifestAttributes_574249; name: string;
          reference: string; value: JsonNode = nil): Recallable =
  ## updateAcrManifestAttributes
  ## Update attributes of a manifest
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  ##   value: JObject
  ##        : Repository attribute value
  var path_574257 = newJObject()
  var body_574258 = newJObject()
  add(path_574257, "name", newJString(name))
  add(path_574257, "reference", newJString(reference))
  if value != nil:
    body_574258 = value
  result = call_574256.call(path_574257, nil, nil, nil, body_574258)

var updateAcrManifestAttributes* = Call_UpdateAcrManifestAttributes_574249(
    name: "updateAcrManifestAttributes", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/acr/v1/{name}/_manifests/{reference}",
    validator: validate_UpdateAcrManifestAttributes_574250, base: "",
    url: url_UpdateAcrManifestAttributes_574251, schemes: {Scheme.Https})
type
  Call_GetAcrTags_574259 = ref object of OpenApiRestCall_573657
proc url_GetAcrTags_574261(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/_tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetAcrTags_574260(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## List tags of a repository
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574262 = path.getOrDefault("name")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = nil)
  if valid_574262 != nil:
    section.add "name", valid_574262
  result.add "path", section
  ## parameters in `query` object:
  ##   digest: JString
  ##         : filter by digest
  ##   orderby: JString
  ##          : orderby query parameter
  ##   last: JString
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: JInt
  ##    : query parameter for max number of items
  section = newJObject()
  var valid_574263 = query.getOrDefault("digest")
  valid_574263 = validateParameter(valid_574263, JString, required = false,
                                 default = nil)
  if valid_574263 != nil:
    section.add "digest", valid_574263
  var valid_574264 = query.getOrDefault("orderby")
  valid_574264 = validateParameter(valid_574264, JString, required = false,
                                 default = nil)
  if valid_574264 != nil:
    section.add "orderby", valid_574264
  var valid_574265 = query.getOrDefault("last")
  valid_574265 = validateParameter(valid_574265, JString, required = false,
                                 default = nil)
  if valid_574265 != nil:
    section.add "last", valid_574265
  var valid_574266 = query.getOrDefault("n")
  valid_574266 = validateParameter(valid_574266, JInt, required = false, default = nil)
  if valid_574266 != nil:
    section.add "n", valid_574266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574267: Call_GetAcrTags_574259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List tags of a repository
  ## 
  let valid = call_574267.validator(path, query, header, formData, body)
  let scheme = call_574267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574267.url(scheme.get, call_574267.host, call_574267.base,
                         call_574267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574267, url, valid)

proc call*(call_574268: Call_GetAcrTags_574259; name: string; digest: string = "";
          orderby: string = ""; last: string = ""; n: int = 0): Recallable =
  ## getAcrTags
  ## List tags of a repository
  ##   digest: string
  ##         : filter by digest
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   orderby: string
  ##          : orderby query parameter
  ##   last: string
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: int
  ##    : query parameter for max number of items
  var path_574269 = newJObject()
  var query_574270 = newJObject()
  add(query_574270, "digest", newJString(digest))
  add(path_574269, "name", newJString(name))
  add(query_574270, "orderby", newJString(orderby))
  add(query_574270, "last", newJString(last))
  add(query_574270, "n", newJInt(n))
  result = call_574268.call(path_574269, query_574270, nil, nil, nil)

var getAcrTags* = Call_GetAcrTags_574259(name: "getAcrTags",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/acr/v1/{name}/_tags",
                                      validator: validate_GetAcrTags_574260,
                                      base: "", url: url_GetAcrTags_574261,
                                      schemes: {Scheme.Https})
type
  Call_GetAcrTagAttributes_574271 = ref object of OpenApiRestCall_573657
proc url_GetAcrTagAttributes_574273(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "reference" in path, "`reference` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/_tags/"),
               (kind: VariableSegment, value: "reference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetAcrTagAttributes_574272(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get tag attributes by tag
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : Tag or digest of the target manifest
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574274 = path.getOrDefault("name")
  valid_574274 = validateParameter(valid_574274, JString, required = true,
                                 default = nil)
  if valid_574274 != nil:
    section.add "name", valid_574274
  var valid_574275 = path.getOrDefault("reference")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "reference", valid_574275
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574276: Call_GetAcrTagAttributes_574271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag attributes by tag
  ## 
  let valid = call_574276.validator(path, query, header, formData, body)
  let scheme = call_574276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574276.url(scheme.get, call_574276.host, call_574276.base,
                         call_574276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574276, url, valid)

proc call*(call_574277: Call_GetAcrTagAttributes_574271; name: string;
          reference: string): Recallable =
  ## getAcrTagAttributes
  ## Get tag attributes by tag
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : Tag or digest of the target manifest
  var path_574278 = newJObject()
  add(path_574278, "name", newJString(name))
  add(path_574278, "reference", newJString(reference))
  result = call_574277.call(path_574278, nil, nil, nil, nil)

var getAcrTagAttributes* = Call_GetAcrTagAttributes_574271(
    name: "getAcrTagAttributes", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}/_tags/{reference}",
    validator: validate_GetAcrTagAttributes_574272, base: "",
    url: url_GetAcrTagAttributes_574273, schemes: {Scheme.Https})
type
  Call_UpdateAcrTagAttributes_574287 = ref object of OpenApiRestCall_573657
proc url_UpdateAcrTagAttributes_574289(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "reference" in path, "`reference` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/_tags/"),
               (kind: VariableSegment, value: "reference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateAcrTagAttributes_574288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update tag attributes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : Tag or digest of the target manifest
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574290 = path.getOrDefault("name")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "name", valid_574290
  var valid_574291 = path.getOrDefault("reference")
  valid_574291 = validateParameter(valid_574291, JString, required = true,
                                 default = nil)
  if valid_574291 != nil:
    section.add "reference", valid_574291
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   value: JObject
  ##        : Repository attribute value
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574293: Call_UpdateAcrTagAttributes_574287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tag attributes
  ## 
  let valid = call_574293.validator(path, query, header, formData, body)
  let scheme = call_574293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574293.url(scheme.get, call_574293.host, call_574293.base,
                         call_574293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574293, url, valid)

proc call*(call_574294: Call_UpdateAcrTagAttributes_574287; name: string;
          reference: string; value: JsonNode = nil): Recallable =
  ## updateAcrTagAttributes
  ## Update tag attributes
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : Tag or digest of the target manifest
  ##   value: JObject
  ##        : Repository attribute value
  var path_574295 = newJObject()
  var body_574296 = newJObject()
  add(path_574295, "name", newJString(name))
  add(path_574295, "reference", newJString(reference))
  if value != nil:
    body_574296 = value
  result = call_574294.call(path_574295, nil, nil, nil, body_574296)

var updateAcrTagAttributes* = Call_UpdateAcrTagAttributes_574287(
    name: "updateAcrTagAttributes", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/acr/v1/{name}/_tags/{reference}",
    validator: validate_UpdateAcrTagAttributes_574288, base: "",
    url: url_UpdateAcrTagAttributes_574289, schemes: {Scheme.Https})
type
  Call_DeleteAcrTag_574279 = ref object of OpenApiRestCall_573657
proc url_DeleteAcrTag_574281(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "reference" in path, "`reference` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/acr/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/_tags/"),
               (kind: VariableSegment, value: "reference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteAcrTag_574280(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete tag
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : Tag or digest of the target manifest
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574282 = path.getOrDefault("name")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "name", valid_574282
  var valid_574283 = path.getOrDefault("reference")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "reference", valid_574283
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574284: Call_DeleteAcrTag_574279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete tag
  ## 
  let valid = call_574284.validator(path, query, header, formData, body)
  let scheme = call_574284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574284.url(scheme.get, call_574284.host, call_574284.base,
                         call_574284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574284, url, valid)

proc call*(call_574285: Call_DeleteAcrTag_574279; name: string; reference: string): Recallable =
  ## deleteAcrTag
  ## Delete tag
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : Tag or digest of the target manifest
  var path_574286 = newJObject()
  add(path_574286, "name", newJString(name))
  add(path_574286, "reference", newJString(reference))
  result = call_574285.call(path_574286, nil, nil, nil, nil)

var deleteAcrTag* = Call_DeleteAcrTag_574279(name: "deleteAcrTag",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/acr/v1/{name}/_tags/{reference}", validator: validate_DeleteAcrTag_574280,
    base: "", url: url_DeleteAcrTag_574281, schemes: {Scheme.Https})
type
  Call_GetAcrRefreshTokenFromExchange_574297 = ref object of OpenApiRestCall_573657
proc url_GetAcrRefreshTokenFromExchange_574299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAcrRefreshTokenFromExchange_574298(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exchange AAD tokens for an ACR refresh Token
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   refresh_token: JString
  ##                : AAD refresh token, mandatory when grant_type is access_token_refresh_token or refresh_token
  ##   tenant: JString
  ##         : AAD tenant associated to the AAD credentials.
  ##   grant_type: JString (required)
  ##             : Can take a value of access_token_refresh_token, or access_token, or refresh_token
  ##   access_token: JString
  ##               : AAD access token, mandatory when grant_type is access_token_refresh_token or access_token.
  ##   service: JString (required)
  ##          : Indicates the name of your Azure container registry.
  section = newJObject()
  var valid_574300 = formData.getOrDefault("refresh_token")
  valid_574300 = validateParameter(valid_574300, JString, required = false,
                                 default = nil)
  if valid_574300 != nil:
    section.add "refresh_token", valid_574300
  var valid_574301 = formData.getOrDefault("tenant")
  valid_574301 = validateParameter(valid_574301, JString, required = false,
                                 default = nil)
  if valid_574301 != nil:
    section.add "tenant", valid_574301
  assert formData != nil,
        "formData argument is necessary due to required `grant_type` field"
  var valid_574315 = formData.getOrDefault("grant_type")
  valid_574315 = validateParameter(valid_574315, JString, required = true, default = newJString(
      "access_token_refresh_token"))
  if valid_574315 != nil:
    section.add "grant_type", valid_574315
  var valid_574316 = formData.getOrDefault("access_token")
  valid_574316 = validateParameter(valid_574316, JString, required = false,
                                 default = nil)
  if valid_574316 != nil:
    section.add "access_token", valid_574316
  var valid_574317 = formData.getOrDefault("service")
  valid_574317 = validateParameter(valid_574317, JString, required = true,
                                 default = nil)
  if valid_574317 != nil:
    section.add "service", valid_574317
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574318: Call_GetAcrRefreshTokenFromExchange_574297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exchange AAD tokens for an ACR refresh Token
  ## 
  let valid = call_574318.validator(path, query, header, formData, body)
  let scheme = call_574318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574318.url(scheme.get, call_574318.host, call_574318.base,
                         call_574318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574318, url, valid)

proc call*(call_574319: Call_GetAcrRefreshTokenFromExchange_574297;
          service: string; refreshToken: string = ""; tenant: string = "";
          grantType: string = "access_token_refresh_token"; accessToken: string = ""): Recallable =
  ## getAcrRefreshTokenFromExchange
  ## Exchange AAD tokens for an ACR refresh Token
  ##   refreshToken: string
  ##               : AAD refresh token, mandatory when grant_type is access_token_refresh_token or refresh_token
  ##   tenant: string
  ##         : AAD tenant associated to the AAD credentials.
  ##   grantType: string (required)
  ##            : Can take a value of access_token_refresh_token, or access_token, or refresh_token
  ##   accessToken: string
  ##              : AAD access token, mandatory when grant_type is access_token_refresh_token or access_token.
  ##   service: string (required)
  ##          : Indicates the name of your Azure container registry.
  var formData_574320 = newJObject()
  add(formData_574320, "refresh_token", newJString(refreshToken))
  add(formData_574320, "tenant", newJString(tenant))
  add(formData_574320, "grant_type", newJString(grantType))
  add(formData_574320, "access_token", newJString(accessToken))
  add(formData_574320, "service", newJString(service))
  result = call_574319.call(nil, nil, nil, formData_574320, nil)

var getAcrRefreshTokenFromExchange* = Call_GetAcrRefreshTokenFromExchange_574297(
    name: "getAcrRefreshTokenFromExchange", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/oauth2/exchange",
    validator: validate_GetAcrRefreshTokenFromExchange_574298, base: "",
    url: url_GetAcrRefreshTokenFromExchange_574299, schemes: {Scheme.Https})
type
  Call_GetAcrAccessToken_574329 = ref object of OpenApiRestCall_573657
proc url_GetAcrAccessToken_574331(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAcrAccessToken_574330(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Exchange ACR Refresh token for an ACR Access Token
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   scope: JString (required)
  ##        : Which is expected to be a valid scope, and can be specified more than once for multiple scope requests. You obtained this from the Www-Authenticate response header from the challenge.
  ##   refresh_token: JString (required)
  ##                : Must be a valid ACR refresh token
  ##   grant_type: JString (required)
  ##             : Grant type is expected to be refresh_token
  ##   service: JString (required)
  ##          : Indicates the name of your Azure container registry.
  section = newJObject()
  assert formData != nil,
        "formData argument is necessary due to required `scope` field"
  var valid_574332 = formData.getOrDefault("scope")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "scope", valid_574332
  var valid_574333 = formData.getOrDefault("refresh_token")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "refresh_token", valid_574333
  var valid_574334 = formData.getOrDefault("grant_type")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = newJString("refresh_token"))
  if valid_574334 != nil:
    section.add "grant_type", valid_574334
  var valid_574335 = formData.getOrDefault("service")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "service", valid_574335
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574336: Call_GetAcrAccessToken_574329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exchange ACR Refresh token for an ACR Access Token
  ## 
  let valid = call_574336.validator(path, query, header, formData, body)
  let scheme = call_574336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574336.url(scheme.get, call_574336.host, call_574336.base,
                         call_574336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574336, url, valid)

proc call*(call_574337: Call_GetAcrAccessToken_574329; scope: string;
          refreshToken: string; service: string; grantType: string = "refresh_token"): Recallable =
  ## getAcrAccessToken
  ## Exchange ACR Refresh token for an ACR Access Token
  ##   scope: string (required)
  ##        : Which is expected to be a valid scope, and can be specified more than once for multiple scope requests. You obtained this from the Www-Authenticate response header from the challenge.
  ##   refreshToken: string (required)
  ##               : Must be a valid ACR refresh token
  ##   grantType: string (required)
  ##            : Grant type is expected to be refresh_token
  ##   service: string (required)
  ##          : Indicates the name of your Azure container registry.
  var formData_574338 = newJObject()
  add(formData_574338, "scope", newJString(scope))
  add(formData_574338, "refresh_token", newJString(refreshToken))
  add(formData_574338, "grant_type", newJString(grantType))
  add(formData_574338, "service", newJString(service))
  result = call_574337.call(nil, nil, nil, formData_574338, nil)

var getAcrAccessToken* = Call_GetAcrAccessToken_574329(name: "getAcrAccessToken",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/oauth2/token",
    validator: validate_GetAcrAccessToken_574330, base: "",
    url: url_GetAcrAccessToken_574331, schemes: {Scheme.Https})
type
  Call_GetAcrAccessTokenFromLogin_574321 = ref object of OpenApiRestCall_573657
proc url_GetAcrAccessTokenFromLogin_574323(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAcrAccessTokenFromLogin_574322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exchange Username, Password and Scope an ACR Access Token
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   service: JString (required)
  ##          : Indicates the name of your Azure container registry.
  ##   scope: JString (required)
  ##        : Expected to be a valid scope, and can be specified more than once for multiple scope requests. You can obtain this from the Www-Authenticate response header from the challenge.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `service` field"
  var valid_574324 = query.getOrDefault("service")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "service", valid_574324
  var valid_574325 = query.getOrDefault("scope")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "scope", valid_574325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574326: Call_GetAcrAccessTokenFromLogin_574321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exchange Username, Password and Scope an ACR Access Token
  ## 
  let valid = call_574326.validator(path, query, header, formData, body)
  let scheme = call_574326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574326.url(scheme.get, call_574326.host, call_574326.base,
                         call_574326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574326, url, valid)

proc call*(call_574327: Call_GetAcrAccessTokenFromLogin_574321; service: string;
          scope: string): Recallable =
  ## getAcrAccessTokenFromLogin
  ## Exchange Username, Password and Scope an ACR Access Token
  ##   service: string (required)
  ##          : Indicates the name of your Azure container registry.
  ##   scope: string (required)
  ##        : Expected to be a valid scope, and can be specified more than once for multiple scope requests. You can obtain this from the Www-Authenticate response header from the challenge.
  var query_574328 = newJObject()
  add(query_574328, "service", newJString(service))
  add(query_574328, "scope", newJString(scope))
  result = call_574327.call(nil, query_574328, nil, nil, nil)

var getAcrAccessTokenFromLogin* = Call_GetAcrAccessTokenFromLogin_574321(
    name: "getAcrAccessTokenFromLogin", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/oauth2/token",
    validator: validate_GetAcrAccessTokenFromLogin_574322, base: "",
    url: url_GetAcrAccessTokenFromLogin_574323, schemes: {Scheme.Https})
type
  Call_GetDockerRegistryV2Support_574339 = ref object of OpenApiRestCall_573657
proc url_GetDockerRegistryV2Support_574341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDockerRegistryV2Support_574340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tells whether this Docker Registry instance supports Docker Registry HTTP API v2
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574342: Call_GetDockerRegistryV2Support_574339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tells whether this Docker Registry instance supports Docker Registry HTTP API v2
  ## 
  let valid = call_574342.validator(path, query, header, formData, body)
  let scheme = call_574342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574342.url(scheme.get, call_574342.host, call_574342.base,
                         call_574342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574342, url, valid)

proc call*(call_574343: Call_GetDockerRegistryV2Support_574339): Recallable =
  ## getDockerRegistryV2Support
  ## Tells whether this Docker Registry instance supports Docker Registry HTTP API v2
  result = call_574343.call(nil, nil, nil, nil, nil)

var getDockerRegistryV2Support* = Call_GetDockerRegistryV2Support_574339(
    name: "getDockerRegistryV2Support", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/v2/",
    validator: validate_GetDockerRegistryV2Support_574340, base: "",
    url: url_GetDockerRegistryV2Support_574341, schemes: {Scheme.Https})
type
  Call_GetRepositories_574344 = ref object of OpenApiRestCall_573657
proc url_GetRepositories_574346(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetRepositories_574345(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List repositories
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   last: JString
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: JInt
  ##    : query parameter for max number of items
  section = newJObject()
  var valid_574347 = query.getOrDefault("last")
  valid_574347 = validateParameter(valid_574347, JString, required = false,
                                 default = nil)
  if valid_574347 != nil:
    section.add "last", valid_574347
  var valid_574348 = query.getOrDefault("n")
  valid_574348 = validateParameter(valid_574348, JInt, required = false, default = nil)
  if valid_574348 != nil:
    section.add "n", valid_574348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574349: Call_GetRepositories_574344; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List repositories
  ## 
  let valid = call_574349.validator(path, query, header, formData, body)
  let scheme = call_574349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574349.url(scheme.get, call_574349.host, call_574349.base,
                         call_574349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574349, url, valid)

proc call*(call_574350: Call_GetRepositories_574344; last: string = ""; n: int = 0): Recallable =
  ## getRepositories
  ## List repositories
  ##   last: string
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: int
  ##    : query parameter for max number of items
  var query_574351 = newJObject()
  add(query_574351, "last", newJString(last))
  add(query_574351, "n", newJInt(n))
  result = call_574350.call(nil, query_574351, nil, nil, nil)

var getRepositories* = Call_GetRepositories_574344(name: "getRepositories",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/v2/_catalog",
    validator: validate_GetRepositories_574345, base: "", url: url_GetRepositories_574346,
    schemes: {Scheme.Https})
type
  Call_CreateManifest_574361 = ref object of OpenApiRestCall_573657
proc url_CreateManifest_574363(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "reference" in path, "`reference` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/manifests/"),
               (kind: VariableSegment, value: "reference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CreateManifest_574362(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Put the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : A tag or a digest, pointing to a specific image
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574374 = path.getOrDefault("name")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "name", valid_574374
  var valid_574375 = path.getOrDefault("reference")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "reference", valid_574375
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   payload: JObject (required)
  ##          : Manifest body, can take v1 or v2 values depending on accept header
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574377: Call_CreateManifest_574361; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Put the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
  ## 
  let valid = call_574377.validator(path, query, header, formData, body)
  let scheme = call_574377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574377.url(scheme.get, call_574377.host, call_574377.base,
                         call_574377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574377, url, valid)

proc call*(call_574378: Call_CreateManifest_574361; name: string; reference: string;
          payload: JsonNode): Recallable =
  ## createManifest
  ## Put the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  ##   payload: JObject (required)
  ##          : Manifest body, can take v1 or v2 values depending on accept header
  var path_574379 = newJObject()
  var body_574380 = newJObject()
  add(path_574379, "name", newJString(name))
  add(path_574379, "reference", newJString(reference))
  if payload != nil:
    body_574380 = payload
  result = call_574378.call(path_574379, nil, nil, nil, body_574380)

var createManifest* = Call_CreateManifest_574361(name: "createManifest",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/v2/{name}/manifests/{reference}", validator: validate_CreateManifest_574362,
    base: "", url: url_CreateManifest_574363, schemes: {Scheme.Https})
type
  Call_GetManifest_574352 = ref object of OpenApiRestCall_573657
proc url_GetManifest_574354(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "reference" in path, "`reference` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/manifests/"),
               (kind: VariableSegment, value: "reference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetManifest_574353(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Pulls the image manifest file associated with the specified name and reference. Reference may be a tag or a digest
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : A tag or a digest, pointing to a specific image
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574355 = path.getOrDefault("name")
  valid_574355 = validateParameter(valid_574355, JString, required = true,
                                 default = nil)
  if valid_574355 != nil:
    section.add "name", valid_574355
  var valid_574356 = path.getOrDefault("reference")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "reference", valid_574356
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   accept: JString
  ##         : Accept header string delimited by comma. For example, application/vnd.docker.distribution.manifest.v2+json
  section = newJObject()
  var valid_574357 = header.getOrDefault("accept")
  valid_574357 = validateParameter(valid_574357, JString, required = false,
                                 default = nil)
  if valid_574357 != nil:
    section.add "accept", valid_574357
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574358: Call_GetManifest_574352; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pulls the image manifest file associated with the specified name and reference. Reference may be a tag or a digest
  ## 
  let valid = call_574358.validator(path, query, header, formData, body)
  let scheme = call_574358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574358.url(scheme.get, call_574358.host, call_574358.base,
                         call_574358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574358, url, valid)

proc call*(call_574359: Call_GetManifest_574352; name: string; reference: string): Recallable =
  ## getManifest
  ## Pulls the image manifest file associated with the specified name and reference. Reference may be a tag or a digest
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_574360 = newJObject()
  add(path_574360, "name", newJString(name))
  add(path_574360, "reference", newJString(reference))
  result = call_574359.call(path_574360, nil, nil, nil, nil)

var getManifest* = Call_GetManifest_574352(name: "getManifest",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/v2/{name}/manifests/{reference}",
                                        validator: validate_GetManifest_574353,
                                        base: "", url: url_GetManifest_574354,
                                        schemes: {Scheme.Https})
type
  Call_DeleteManifest_574381 = ref object of OpenApiRestCall_573657
proc url_DeleteManifest_574383(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "reference" in path, "`reference` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/manifests/"),
               (kind: VariableSegment, value: "reference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteManifest_574382(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete the manifest identified by `name` and `reference`. Note that a manifest can _only_ be deleted by `digest`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : A tag or a digest, pointing to a specific image
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574384 = path.getOrDefault("name")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "name", valid_574384
  var valid_574385 = path.getOrDefault("reference")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "reference", valid_574385
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574386: Call_DeleteManifest_574381; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the manifest identified by `name` and `reference`. Note that a manifest can _only_ be deleted by `digest`.
  ## 
  let valid = call_574386.validator(path, query, header, formData, body)
  let scheme = call_574386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574386.url(scheme.get, call_574386.host, call_574386.base,
                         call_574386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574386, url, valid)

proc call*(call_574387: Call_DeleteManifest_574381; name: string; reference: string): Recallable =
  ## deleteManifest
  ## Delete the manifest identified by `name` and `reference`. Note that a manifest can _only_ be deleted by `digest`.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_574388 = newJObject()
  add(path_574388, "name", newJString(name))
  add(path_574388, "reference", newJString(reference))
  result = call_574387.call(path_574388, nil, nil, nil, nil)

var deleteManifest* = Call_DeleteManifest_574381(name: "deleteManifest",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/v2/{name}/manifests/{reference}", validator: validate_DeleteManifest_574382,
    base: "", url: url_DeleteManifest_574383, schemes: {Scheme.Https})
type
  Call_GetTagList_574389 = ref object of OpenApiRestCall_573657
proc url_GetTagList_574391(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/tags/list")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetTagList_574390(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetch the tags under the repository identified by name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574392 = path.getOrDefault("name")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "name", valid_574392
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574393: Call_GetTagList_574389; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the tags under the repository identified by name
  ## 
  let valid = call_574393.validator(path, query, header, formData, body)
  let scheme = call_574393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574393.url(scheme.get, call_574393.host, call_574393.base,
                         call_574393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574393, url, valid)

proc call*(call_574394: Call_GetTagList_574389; name: string): Recallable =
  ## getTagList
  ## Fetch the tags under the repository identified by name
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  var path_574395 = newJObject()
  add(path_574395, "name", newJString(name))
  result = call_574394.call(path_574395, nil, nil, nil, nil)

var getTagList* = Call_GetTagList_574389(name: "getTagList",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/v2/{name}/tags/list",
                                      validator: validate_GetTagList_574390,
                                      base: "", url: url_GetTagList_574391,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
