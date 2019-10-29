
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "containerregistry"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetAcrRepositories_563777 = ref object of OpenApiRestCall_563555
proc url_GetAcrRepositories_563779(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAcrRepositories_563778(path: JsonNode; query: JsonNode;
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
  var valid_563940 = query.getOrDefault("last")
  valid_563940 = validateParameter(valid_563940, JString, required = false,
                                 default = nil)
  if valid_563940 != nil:
    section.add "last", valid_563940
  var valid_563941 = query.getOrDefault("n")
  valid_563941 = validateParameter(valid_563941, JInt, required = false, default = nil)
  if valid_563941 != nil:
    section.add "n", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_GetAcrRepositories_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List repositories
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_GetAcrRepositories_563777; last: string = ""; n: int = 0): Recallable =
  ## getAcrRepositories
  ## List repositories
  ##   last: string
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: int
  ##    : query parameter for max number of items
  var query_564036 = newJObject()
  add(query_564036, "last", newJString(last))
  add(query_564036, "n", newJInt(n))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var getAcrRepositories* = Call_GetAcrRepositories_563777(
    name: "getAcrRepositories", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/_catalog", validator: validate_GetAcrRepositories_563778,
    base: "", url: url_GetAcrRepositories_563779, schemes: {Scheme.Https})
type
  Call_GetAcrRepositoryAttributes_564076 = ref object of OpenApiRestCall_563555
proc url_GetAcrRepositoryAttributes_564078(protocol: Scheme; host: string;
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

proc validate_GetAcrRepositoryAttributes_564077(path: JsonNode; query: JsonNode;
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
  var valid_564093 = path.getOrDefault("name")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "name", valid_564093
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564094: Call_GetAcrRepositoryAttributes_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get repository attributes
  ## 
  let valid = call_564094.validator(path, query, header, formData, body)
  let scheme = call_564094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564094.url(scheme.get, call_564094.host, call_564094.base,
                         call_564094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564094, url, valid)

proc call*(call_564095: Call_GetAcrRepositoryAttributes_564076; name: string): Recallable =
  ## getAcrRepositoryAttributes
  ## Get repository attributes
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  var path_564096 = newJObject()
  add(path_564096, "name", newJString(name))
  result = call_564095.call(path_564096, nil, nil, nil, nil)

var getAcrRepositoryAttributes* = Call_GetAcrRepositoryAttributes_564076(
    name: "getAcrRepositoryAttributes", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/acr/v1/{name}",
    validator: validate_GetAcrRepositoryAttributes_564077, base: "",
    url: url_GetAcrRepositoryAttributes_564078, schemes: {Scheme.Https})
type
  Call_UpdateAcrRepositoryAttributes_564104 = ref object of OpenApiRestCall_563555
proc url_UpdateAcrRepositoryAttributes_564106(protocol: Scheme; host: string;
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

proc validate_UpdateAcrRepositoryAttributes_564105(path: JsonNode; query: JsonNode;
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
  var valid_564124 = path.getOrDefault("name")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "name", valid_564124
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

proc call*(call_564126: Call_UpdateAcrRepositoryAttributes_564104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the attribute identified by `name` where `reference` is the name of the repository.
  ## 
  let valid = call_564126.validator(path, query, header, formData, body)
  let scheme = call_564126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564126.url(scheme.get, call_564126.host, call_564126.base,
                         call_564126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564126, url, valid)

proc call*(call_564127: Call_UpdateAcrRepositoryAttributes_564104; name: string;
          value: JsonNode = nil): Recallable =
  ## updateAcrRepositoryAttributes
  ## Update the attribute identified by `name` where `reference` is the name of the repository.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   value: JObject
  ##        : Repository attribute value
  var path_564128 = newJObject()
  var body_564129 = newJObject()
  add(path_564128, "name", newJString(name))
  if value != nil:
    body_564129 = value
  result = call_564127.call(path_564128, nil, nil, nil, body_564129)

var updateAcrRepositoryAttributes* = Call_UpdateAcrRepositoryAttributes_564104(
    name: "updateAcrRepositoryAttributes", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/acr/v1/{name}",
    validator: validate_UpdateAcrRepositoryAttributes_564105, base: "",
    url: url_UpdateAcrRepositoryAttributes_564106, schemes: {Scheme.Https})
type
  Call_DeleteAcrRepository_564097 = ref object of OpenApiRestCall_563555
proc url_DeleteAcrRepository_564099(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteAcrRepository_564098(path: JsonNode; query: JsonNode;
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
  var valid_564100 = path.getOrDefault("name")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "name", valid_564100
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564101: Call_DeleteAcrRepository_564097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the repository identified by `name`
  ## 
  let valid = call_564101.validator(path, query, header, formData, body)
  let scheme = call_564101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564101.url(scheme.get, call_564101.host, call_564101.base,
                         call_564101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564101, url, valid)

proc call*(call_564102: Call_DeleteAcrRepository_564097; name: string): Recallable =
  ## deleteAcrRepository
  ## Delete the repository identified by `name`
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  var path_564103 = newJObject()
  add(path_564103, "name", newJString(name))
  result = call_564102.call(path_564103, nil, nil, nil, nil)

var deleteAcrRepository* = Call_DeleteAcrRepository_564097(
    name: "deleteAcrRepository", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/acr/v1/{name}", validator: validate_DeleteAcrRepository_564098,
    base: "", url: url_DeleteAcrRepository_564099, schemes: {Scheme.Https})
type
  Call_GetAcrManifests_564130 = ref object of OpenApiRestCall_563555
proc url_GetAcrManifests_564132(protocol: Scheme; host: string; base: string;
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

proc validate_GetAcrManifests_564131(path: JsonNode; query: JsonNode;
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
  var valid_564133 = path.getOrDefault("name")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "name", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   last: JString
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   orderby: JString
  ##          : orderby query parameter
  ##   n: JInt
  ##    : query parameter for max number of items
  section = newJObject()
  var valid_564134 = query.getOrDefault("last")
  valid_564134 = validateParameter(valid_564134, JString, required = false,
                                 default = nil)
  if valid_564134 != nil:
    section.add "last", valid_564134
  var valid_564135 = query.getOrDefault("orderby")
  valid_564135 = validateParameter(valid_564135, JString, required = false,
                                 default = nil)
  if valid_564135 != nil:
    section.add "orderby", valid_564135
  var valid_564136 = query.getOrDefault("n")
  valid_564136 = validateParameter(valid_564136, JInt, required = false, default = nil)
  if valid_564136 != nil:
    section.add "n", valid_564136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_GetAcrManifests_564130; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List manifests of a repository
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_GetAcrManifests_564130; name: string; last: string = "";
          orderby: string = ""; n: int = 0): Recallable =
  ## getAcrManifests
  ## List manifests of a repository
  ##   last: string
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   orderby: string
  ##          : orderby query parameter
  ##   n: int
  ##    : query parameter for max number of items
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  add(query_564140, "last", newJString(last))
  add(path_564139, "name", newJString(name))
  add(query_564140, "orderby", newJString(orderby))
  add(query_564140, "n", newJInt(n))
  result = call_564138.call(path_564139, query_564140, nil, nil, nil)

var getAcrManifests* = Call_GetAcrManifests_564130(name: "getAcrManifests",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}/_manifests", validator: validate_GetAcrManifests_564131,
    base: "", url: url_GetAcrManifests_564132, schemes: {Scheme.Https})
type
  Call_GetAcrManifestAttributes_564141 = ref object of OpenApiRestCall_563555
proc url_GetAcrManifestAttributes_564143(protocol: Scheme; host: string;
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

proc validate_GetAcrManifestAttributes_564142(path: JsonNode; query: JsonNode;
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
  var valid_564144 = path.getOrDefault("name")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "name", valid_564144
  var valid_564145 = path.getOrDefault("reference")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "reference", valid_564145
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_GetAcrManifestAttributes_564141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get manifest attributes
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_GetAcrManifestAttributes_564141; name: string;
          reference: string): Recallable =
  ## getAcrManifestAttributes
  ## Get manifest attributes
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_564148 = newJObject()
  add(path_564148, "name", newJString(name))
  add(path_564148, "reference", newJString(reference))
  result = call_564147.call(path_564148, nil, nil, nil, nil)

var getAcrManifestAttributes* = Call_GetAcrManifestAttributes_564141(
    name: "getAcrManifestAttributes", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}/_manifests/{reference}",
    validator: validate_GetAcrManifestAttributes_564142, base: "",
    url: url_GetAcrManifestAttributes_564143, schemes: {Scheme.Https})
type
  Call_UpdateAcrManifestAttributes_564149 = ref object of OpenApiRestCall_563555
proc url_UpdateAcrManifestAttributes_564151(protocol: Scheme; host: string;
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

proc validate_UpdateAcrManifestAttributes_564150(path: JsonNode; query: JsonNode;
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
  var valid_564152 = path.getOrDefault("name")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "name", valid_564152
  var valid_564153 = path.getOrDefault("reference")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "reference", valid_564153
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

proc call*(call_564155: Call_UpdateAcrManifestAttributes_564149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update attributes of a manifest
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_UpdateAcrManifestAttributes_564149; name: string;
          reference: string; value: JsonNode = nil): Recallable =
  ## updateAcrManifestAttributes
  ## Update attributes of a manifest
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   value: JObject
  ##        : Repository attribute value
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_564157 = newJObject()
  var body_564158 = newJObject()
  add(path_564157, "name", newJString(name))
  if value != nil:
    body_564158 = value
  add(path_564157, "reference", newJString(reference))
  result = call_564156.call(path_564157, nil, nil, nil, body_564158)

var updateAcrManifestAttributes* = Call_UpdateAcrManifestAttributes_564149(
    name: "updateAcrManifestAttributes", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/acr/v1/{name}/_manifests/{reference}",
    validator: validate_UpdateAcrManifestAttributes_564150, base: "",
    url: url_UpdateAcrManifestAttributes_564151, schemes: {Scheme.Https})
type
  Call_GetAcrTags_564159 = ref object of OpenApiRestCall_563555
proc url_GetAcrTags_564161(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetAcrTags_564160(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564162 = path.getOrDefault("name")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "name", valid_564162
  result.add "path", section
  ## parameters in `query` object:
  ##   last: JString
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   digest: JString
  ##         : filter by digest
  ##   orderby: JString
  ##          : orderby query parameter
  ##   n: JInt
  ##    : query parameter for max number of items
  section = newJObject()
  var valid_564163 = query.getOrDefault("last")
  valid_564163 = validateParameter(valid_564163, JString, required = false,
                                 default = nil)
  if valid_564163 != nil:
    section.add "last", valid_564163
  var valid_564164 = query.getOrDefault("digest")
  valid_564164 = validateParameter(valid_564164, JString, required = false,
                                 default = nil)
  if valid_564164 != nil:
    section.add "digest", valid_564164
  var valid_564165 = query.getOrDefault("orderby")
  valid_564165 = validateParameter(valid_564165, JString, required = false,
                                 default = nil)
  if valid_564165 != nil:
    section.add "orderby", valid_564165
  var valid_564166 = query.getOrDefault("n")
  valid_564166 = validateParameter(valid_564166, JInt, required = false, default = nil)
  if valid_564166 != nil:
    section.add "n", valid_564166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_GetAcrTags_564159; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List tags of a repository
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_GetAcrTags_564159; name: string; last: string = "";
          digest: string = ""; orderby: string = ""; n: int = 0): Recallable =
  ## getAcrTags
  ## List tags of a repository
  ##   last: string
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   digest: string
  ##         : filter by digest
  ##   orderby: string
  ##          : orderby query parameter
  ##   n: int
  ##    : query parameter for max number of items
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  add(query_564170, "last", newJString(last))
  add(path_564169, "name", newJString(name))
  add(query_564170, "digest", newJString(digest))
  add(query_564170, "orderby", newJString(orderby))
  add(query_564170, "n", newJInt(n))
  result = call_564168.call(path_564169, query_564170, nil, nil, nil)

var getAcrTags* = Call_GetAcrTags_564159(name: "getAcrTags",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/acr/v1/{name}/_tags",
                                      validator: validate_GetAcrTags_564160,
                                      base: "", url: url_GetAcrTags_564161,
                                      schemes: {Scheme.Https})
type
  Call_GetAcrTagAttributes_564171 = ref object of OpenApiRestCall_563555
proc url_GetAcrTagAttributes_564173(protocol: Scheme; host: string; base: string;
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

proc validate_GetAcrTagAttributes_564172(path: JsonNode; query: JsonNode;
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
  var valid_564174 = path.getOrDefault("name")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "name", valid_564174
  var valid_564175 = path.getOrDefault("reference")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "reference", valid_564175
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_GetAcrTagAttributes_564171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag attributes by tag
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_GetAcrTagAttributes_564171; name: string;
          reference: string): Recallable =
  ## getAcrTagAttributes
  ## Get tag attributes by tag
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : Tag or digest of the target manifest
  var path_564178 = newJObject()
  add(path_564178, "name", newJString(name))
  add(path_564178, "reference", newJString(reference))
  result = call_564177.call(path_564178, nil, nil, nil, nil)

var getAcrTagAttributes* = Call_GetAcrTagAttributes_564171(
    name: "getAcrTagAttributes", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}/_tags/{reference}",
    validator: validate_GetAcrTagAttributes_564172, base: "",
    url: url_GetAcrTagAttributes_564173, schemes: {Scheme.Https})
type
  Call_UpdateAcrTagAttributes_564187 = ref object of OpenApiRestCall_563555
proc url_UpdateAcrTagAttributes_564189(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateAcrTagAttributes_564188(path: JsonNode; query: JsonNode;
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
  var valid_564190 = path.getOrDefault("name")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "name", valid_564190
  var valid_564191 = path.getOrDefault("reference")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "reference", valid_564191
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

proc call*(call_564193: Call_UpdateAcrTagAttributes_564187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tag attributes
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_UpdateAcrTagAttributes_564187; name: string;
          reference: string; value: JsonNode = nil): Recallable =
  ## updateAcrTagAttributes
  ## Update tag attributes
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   value: JObject
  ##        : Repository attribute value
  ##   reference: string (required)
  ##            : Tag or digest of the target manifest
  var path_564195 = newJObject()
  var body_564196 = newJObject()
  add(path_564195, "name", newJString(name))
  if value != nil:
    body_564196 = value
  add(path_564195, "reference", newJString(reference))
  result = call_564194.call(path_564195, nil, nil, nil, body_564196)

var updateAcrTagAttributes* = Call_UpdateAcrTagAttributes_564187(
    name: "updateAcrTagAttributes", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/acr/v1/{name}/_tags/{reference}",
    validator: validate_UpdateAcrTagAttributes_564188, base: "",
    url: url_UpdateAcrTagAttributes_564189, schemes: {Scheme.Https})
type
  Call_DeleteAcrTag_564179 = ref object of OpenApiRestCall_563555
proc url_DeleteAcrTag_564181(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteAcrTag_564180(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564182 = path.getOrDefault("name")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "name", valid_564182
  var valid_564183 = path.getOrDefault("reference")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "reference", valid_564183
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_DeleteAcrTag_564179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete tag
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_DeleteAcrTag_564179; name: string; reference: string): Recallable =
  ## deleteAcrTag
  ## Delete tag
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : Tag or digest of the target manifest
  var path_564186 = newJObject()
  add(path_564186, "name", newJString(name))
  add(path_564186, "reference", newJString(reference))
  result = call_564185.call(path_564186, nil, nil, nil, nil)

var deleteAcrTag* = Call_DeleteAcrTag_564179(name: "deleteAcrTag",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/acr/v1/{name}/_tags/{reference}", validator: validate_DeleteAcrTag_564180,
    base: "", url: url_DeleteAcrTag_564181, schemes: {Scheme.Https})
type
  Call_GetAcrRefreshTokenFromExchange_564197 = ref object of OpenApiRestCall_563555
proc url_GetAcrRefreshTokenFromExchange_564199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAcrRefreshTokenFromExchange_564198(path: JsonNode;
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
  ##   access_token: JString
  ##               : AAD access token, mandatory when grant_type is access_token_refresh_token or access_token.
  ##   tenant: JString
  ##         : AAD tenant associated to the AAD credentials.
  ##   grant_type: JString (required)
  ##             : Can take a value of access_token_refresh_token, or access_token, or refresh_token
  ##   refresh_token: JString
  ##                : AAD refresh token, mandatory when grant_type is access_token_refresh_token or refresh_token
  ##   service: JString (required)
  ##          : Indicates the name of your Azure container registry.
  section = newJObject()
  var valid_564200 = formData.getOrDefault("access_token")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = nil)
  if valid_564200 != nil:
    section.add "access_token", valid_564200
  var valid_564201 = formData.getOrDefault("tenant")
  valid_564201 = validateParameter(valid_564201, JString, required = false,
                                 default = nil)
  if valid_564201 != nil:
    section.add "tenant", valid_564201
  assert formData != nil,
        "formData argument is necessary due to required `grant_type` field"
  var valid_564215 = formData.getOrDefault("grant_type")
  valid_564215 = validateParameter(valid_564215, JString, required = true, default = newJString(
      "access_token_refresh_token"))
  if valid_564215 != nil:
    section.add "grant_type", valid_564215
  var valid_564216 = formData.getOrDefault("refresh_token")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "refresh_token", valid_564216
  var valid_564217 = formData.getOrDefault("service")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "service", valid_564217
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564218: Call_GetAcrRefreshTokenFromExchange_564197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exchange AAD tokens for an ACR refresh Token
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_GetAcrRefreshTokenFromExchange_564197;
          service: string; accessToken: string = ""; tenant: string = "";
          grantType: string = "access_token_refresh_token";
          refreshToken: string = ""): Recallable =
  ## getAcrRefreshTokenFromExchange
  ## Exchange AAD tokens for an ACR refresh Token
  ##   accessToken: string
  ##              : AAD access token, mandatory when grant_type is access_token_refresh_token or access_token.
  ##   tenant: string
  ##         : AAD tenant associated to the AAD credentials.
  ##   grantType: string (required)
  ##            : Can take a value of access_token_refresh_token, or access_token, or refresh_token
  ##   refreshToken: string
  ##               : AAD refresh token, mandatory when grant_type is access_token_refresh_token or refresh_token
  ##   service: string (required)
  ##          : Indicates the name of your Azure container registry.
  var formData_564220 = newJObject()
  add(formData_564220, "access_token", newJString(accessToken))
  add(formData_564220, "tenant", newJString(tenant))
  add(formData_564220, "grant_type", newJString(grantType))
  add(formData_564220, "refresh_token", newJString(refreshToken))
  add(formData_564220, "service", newJString(service))
  result = call_564219.call(nil, nil, nil, formData_564220, nil)

var getAcrRefreshTokenFromExchange* = Call_GetAcrRefreshTokenFromExchange_564197(
    name: "getAcrRefreshTokenFromExchange", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/oauth2/exchange",
    validator: validate_GetAcrRefreshTokenFromExchange_564198, base: "",
    url: url_GetAcrRefreshTokenFromExchange_564199, schemes: {Scheme.Https})
type
  Call_GetAcrAccessToken_564229 = ref object of OpenApiRestCall_563555
proc url_GetAcrAccessToken_564231(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAcrAccessToken_564230(path: JsonNode; query: JsonNode;
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
  ##   grant_type: JString (required)
  ##             : Grant type is expected to be refresh_token
  ##   refresh_token: JString (required)
  ##                : Must be a valid ACR refresh token
  ##   service: JString (required)
  ##          : Indicates the name of your Azure container registry.
  ##   scope: JString (required)
  ##        : Which is expected to be a valid scope, and can be specified more than once for multiple scope requests. You obtained this from the Www-Authenticate response header from the challenge.
  section = newJObject()
  assert formData != nil,
        "formData argument is necessary due to required `grant_type` field"
  var valid_564232 = formData.getOrDefault("grant_type")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = newJString("refresh_token"))
  if valid_564232 != nil:
    section.add "grant_type", valid_564232
  var valid_564233 = formData.getOrDefault("refresh_token")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "refresh_token", valid_564233
  var valid_564234 = formData.getOrDefault("service")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "service", valid_564234
  var valid_564235 = formData.getOrDefault("scope")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "scope", valid_564235
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564236: Call_GetAcrAccessToken_564229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exchange ACR Refresh token for an ACR Access Token
  ## 
  let valid = call_564236.validator(path, query, header, formData, body)
  let scheme = call_564236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564236.url(scheme.get, call_564236.host, call_564236.base,
                         call_564236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564236, url, valid)

proc call*(call_564237: Call_GetAcrAccessToken_564229; refreshToken: string;
          service: string; scope: string; grantType: string = "refresh_token"): Recallable =
  ## getAcrAccessToken
  ## Exchange ACR Refresh token for an ACR Access Token
  ##   grantType: string (required)
  ##            : Grant type is expected to be refresh_token
  ##   refreshToken: string (required)
  ##               : Must be a valid ACR refresh token
  ##   service: string (required)
  ##          : Indicates the name of your Azure container registry.
  ##   scope: string (required)
  ##        : Which is expected to be a valid scope, and can be specified more than once for multiple scope requests. You obtained this from the Www-Authenticate response header from the challenge.
  var formData_564238 = newJObject()
  add(formData_564238, "grant_type", newJString(grantType))
  add(formData_564238, "refresh_token", newJString(refreshToken))
  add(formData_564238, "service", newJString(service))
  add(formData_564238, "scope", newJString(scope))
  result = call_564237.call(nil, nil, nil, formData_564238, nil)

var getAcrAccessToken* = Call_GetAcrAccessToken_564229(name: "getAcrAccessToken",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/oauth2/token",
    validator: validate_GetAcrAccessToken_564230, base: "",
    url: url_GetAcrAccessToken_564231, schemes: {Scheme.Https})
type
  Call_GetAcrAccessTokenFromLogin_564221 = ref object of OpenApiRestCall_563555
proc url_GetAcrAccessTokenFromLogin_564223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAcrAccessTokenFromLogin_564222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exchange Username, Password and Scope an ACR Access Token
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   scope: JString (required)
  ##        : Expected to be a valid scope, and can be specified more than once for multiple scope requests. You can obtain this from the Www-Authenticate response header from the challenge.
  ##   service: JString (required)
  ##          : Indicates the name of your Azure container registry.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `scope` field"
  var valid_564224 = query.getOrDefault("scope")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "scope", valid_564224
  var valid_564225 = query.getOrDefault("service")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "service", valid_564225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_GetAcrAccessTokenFromLogin_564221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exchange Username, Password and Scope an ACR Access Token
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_GetAcrAccessTokenFromLogin_564221; scope: string;
          service: string): Recallable =
  ## getAcrAccessTokenFromLogin
  ## Exchange Username, Password and Scope an ACR Access Token
  ##   scope: string (required)
  ##        : Expected to be a valid scope, and can be specified more than once for multiple scope requests. You can obtain this from the Www-Authenticate response header from the challenge.
  ##   service: string (required)
  ##          : Indicates the name of your Azure container registry.
  var query_564228 = newJObject()
  add(query_564228, "scope", newJString(scope))
  add(query_564228, "service", newJString(service))
  result = call_564227.call(nil, query_564228, nil, nil, nil)

var getAcrAccessTokenFromLogin* = Call_GetAcrAccessTokenFromLogin_564221(
    name: "getAcrAccessTokenFromLogin", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/oauth2/token",
    validator: validate_GetAcrAccessTokenFromLogin_564222, base: "",
    url: url_GetAcrAccessTokenFromLogin_564223, schemes: {Scheme.Https})
type
  Call_GetDockerRegistryV2Support_564239 = ref object of OpenApiRestCall_563555
proc url_GetDockerRegistryV2Support_564241(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetDockerRegistryV2Support_564240(path: JsonNode; query: JsonNode;
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

proc call*(call_564242: Call_GetDockerRegistryV2Support_564239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tells whether this Docker Registry instance supports Docker Registry HTTP API v2
  ## 
  let valid = call_564242.validator(path, query, header, formData, body)
  let scheme = call_564242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564242.url(scheme.get, call_564242.host, call_564242.base,
                         call_564242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564242, url, valid)

proc call*(call_564243: Call_GetDockerRegistryV2Support_564239): Recallable =
  ## getDockerRegistryV2Support
  ## Tells whether this Docker Registry instance supports Docker Registry HTTP API v2
  result = call_564243.call(nil, nil, nil, nil, nil)

var getDockerRegistryV2Support* = Call_GetDockerRegistryV2Support_564239(
    name: "getDockerRegistryV2Support", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/v2/",
    validator: validate_GetDockerRegistryV2Support_564240, base: "",
    url: url_GetDockerRegistryV2Support_564241, schemes: {Scheme.Https})
type
  Call_GetRepositories_564244 = ref object of OpenApiRestCall_563555
proc url_GetRepositories_564246(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetRepositories_564245(path: JsonNode; query: JsonNode;
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
  var valid_564247 = query.getOrDefault("last")
  valid_564247 = validateParameter(valid_564247, JString, required = false,
                                 default = nil)
  if valid_564247 != nil:
    section.add "last", valid_564247
  var valid_564248 = query.getOrDefault("n")
  valid_564248 = validateParameter(valid_564248, JInt, required = false, default = nil)
  if valid_564248 != nil:
    section.add "n", valid_564248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564249: Call_GetRepositories_564244; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List repositories
  ## 
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_GetRepositories_564244; last: string = ""; n: int = 0): Recallable =
  ## getRepositories
  ## List repositories
  ##   last: string
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: int
  ##    : query parameter for max number of items
  var query_564251 = newJObject()
  add(query_564251, "last", newJString(last))
  add(query_564251, "n", newJInt(n))
  result = call_564250.call(nil, query_564251, nil, nil, nil)

var getRepositories* = Call_GetRepositories_564244(name: "getRepositories",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/v2/_catalog",
    validator: validate_GetRepositories_564245, base: "", url: url_GetRepositories_564246,
    schemes: {Scheme.Https})
type
  Call_CreateManifest_564261 = ref object of OpenApiRestCall_563555
proc url_CreateManifest_564263(protocol: Scheme; host: string; base: string;
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

proc validate_CreateManifest_564262(path: JsonNode; query: JsonNode;
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
  var valid_564274 = path.getOrDefault("name")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "name", valid_564274
  var valid_564275 = path.getOrDefault("reference")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "reference", valid_564275
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

proc call*(call_564277: Call_CreateManifest_564261; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Put the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_CreateManifest_564261; name: string; reference: string;
          payload: JsonNode): Recallable =
  ## createManifest
  ## Put the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  ##   payload: JObject (required)
  ##          : Manifest body, can take v1 or v2 values depending on accept header
  var path_564279 = newJObject()
  var body_564280 = newJObject()
  add(path_564279, "name", newJString(name))
  add(path_564279, "reference", newJString(reference))
  if payload != nil:
    body_564280 = payload
  result = call_564278.call(path_564279, nil, nil, nil, body_564280)

var createManifest* = Call_CreateManifest_564261(name: "createManifest",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/v2/{name}/manifests/{reference}", validator: validate_CreateManifest_564262,
    base: "", url: url_CreateManifest_564263, schemes: {Scheme.Https})
type
  Call_GetManifest_564252 = ref object of OpenApiRestCall_563555
proc url_GetManifest_564254(protocol: Scheme; host: string; base: string;
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

proc validate_GetManifest_564253(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564255 = path.getOrDefault("name")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "name", valid_564255
  var valid_564256 = path.getOrDefault("reference")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "reference", valid_564256
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   accept: JString
  ##         : Accept header string delimited by comma. For example, application/vnd.docker.distribution.manifest.v2+json
  section = newJObject()
  var valid_564257 = header.getOrDefault("accept")
  valid_564257 = validateParameter(valid_564257, JString, required = false,
                                 default = nil)
  if valid_564257 != nil:
    section.add "accept", valid_564257
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_GetManifest_564252; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pulls the image manifest file associated with the specified name and reference. Reference may be a tag or a digest
  ## 
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_GetManifest_564252; name: string; reference: string): Recallable =
  ## getManifest
  ## Pulls the image manifest file associated with the specified name and reference. Reference may be a tag or a digest
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_564260 = newJObject()
  add(path_564260, "name", newJString(name))
  add(path_564260, "reference", newJString(reference))
  result = call_564259.call(path_564260, nil, nil, nil, nil)

var getManifest* = Call_GetManifest_564252(name: "getManifest",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local", route: "/v2/{name}/manifests/{reference}",
                                        validator: validate_GetManifest_564253,
                                        base: "", url: url_GetManifest_564254,
                                        schemes: {Scheme.Https})
type
  Call_DeleteManifest_564281 = ref object of OpenApiRestCall_563555
proc url_DeleteManifest_564283(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteManifest_564282(path: JsonNode; query: JsonNode;
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
  var valid_564284 = path.getOrDefault("name")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "name", valid_564284
  var valid_564285 = path.getOrDefault("reference")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "reference", valid_564285
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564286: Call_DeleteManifest_564281; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the manifest identified by `name` and `reference`. Note that a manifest can _only_ be deleted by `digest`.
  ## 
  let valid = call_564286.validator(path, query, header, formData, body)
  let scheme = call_564286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564286.url(scheme.get, call_564286.host, call_564286.base,
                         call_564286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564286, url, valid)

proc call*(call_564287: Call_DeleteManifest_564281; name: string; reference: string): Recallable =
  ## deleteManifest
  ## Delete the manifest identified by `name` and `reference`. Note that a manifest can _only_ be deleted by `digest`.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_564288 = newJObject()
  add(path_564288, "name", newJString(name))
  add(path_564288, "reference", newJString(reference))
  result = call_564287.call(path_564288, nil, nil, nil, nil)

var deleteManifest* = Call_DeleteManifest_564281(name: "deleteManifest",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/v2/{name}/manifests/{reference}", validator: validate_DeleteManifest_564282,
    base: "", url: url_DeleteManifest_564283, schemes: {Scheme.Https})
type
  Call_GetTagList_564289 = ref object of OpenApiRestCall_563555
proc url_GetTagList_564291(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_GetTagList_564290(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564292 = path.getOrDefault("name")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "name", valid_564292
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_GetTagList_564289; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the tags under the repository identified by name
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_GetTagList_564289; name: string): Recallable =
  ## getTagList
  ## Fetch the tags under the repository identified by name
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  var path_564295 = newJObject()
  add(path_564295, "name", newJString(name))
  result = call_564294.call(path_564295, nil, nil, nil, nil)

var getTagList* = Call_GetTagList_564289(name: "getTagList",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/v2/{name}/tags/list",
                                      validator: validate_GetTagList_564290,
                                      base: "", url: url_GetTagList_564291,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
