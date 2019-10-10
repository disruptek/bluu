
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Container Registry
## version: 2019-08-15-preview
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
  Call_RepositoryGetList_573879 = ref object of OpenApiRestCall_573657
proc url_RepositoryGetList_573881(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RepositoryGetList_573880(path: JsonNode; query: JsonNode;
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

proc call*(call_574064: Call_RepositoryGetList_573879; path: JsonNode;
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

proc call*(call_574135: Call_RepositoryGetList_573879; last: string = ""; n: int = 0): Recallable =
  ## repositoryGetList
  ## List repositories
  ##   last: string
  ##       : Query parameter for the last item in previous query. Result set will include values lexically after last.
  ##   n: int
  ##    : query parameter for max number of items
  var query_574136 = newJObject()
  add(query_574136, "last", newJString(last))
  add(query_574136, "n", newJInt(n))
  result = call_574135.call(nil, query_574136, nil, nil, nil)

var repositoryGetList* = Call_RepositoryGetList_573879(name: "repositoryGetList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/acr/v1/_catalog",
    validator: validate_RepositoryGetList_573880, base: "",
    url: url_RepositoryGetList_573881, schemes: {Scheme.Https})
type
  Call_RepositoryGetAttributes_574176 = ref object of OpenApiRestCall_573657
proc url_RepositoryGetAttributes_574178(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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

proc validate_RepositoryGetAttributes_574177(path: JsonNode; query: JsonNode;
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

proc call*(call_574194: Call_RepositoryGetAttributes_574176; path: JsonNode;
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

proc call*(call_574195: Call_RepositoryGetAttributes_574176; name: string): Recallable =
  ## repositoryGetAttributes
  ## Get repository attributes
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  var path_574196 = newJObject()
  add(path_574196, "name", newJString(name))
  result = call_574195.call(path_574196, nil, nil, nil, nil)

var repositoryGetAttributes* = Call_RepositoryGetAttributes_574176(
    name: "repositoryGetAttributes", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}", validator: validate_RepositoryGetAttributes_574177,
    base: "", url: url_RepositoryGetAttributes_574178, schemes: {Scheme.Https})
type
  Call_RepositoryUpdateAttributes_574204 = ref object of OpenApiRestCall_573657
proc url_RepositoryUpdateAttributes_574206(protocol: Scheme; host: string;
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

proc validate_RepositoryUpdateAttributes_574205(path: JsonNode; query: JsonNode;
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

proc call*(call_574226: Call_RepositoryUpdateAttributes_574204; path: JsonNode;
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

proc call*(call_574227: Call_RepositoryUpdateAttributes_574204; name: string;
          value: JsonNode = nil): Recallable =
  ## repositoryUpdateAttributes
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

var repositoryUpdateAttributes* = Call_RepositoryUpdateAttributes_574204(
    name: "repositoryUpdateAttributes", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/acr/v1/{name}",
    validator: validate_RepositoryUpdateAttributes_574205, base: "",
    url: url_RepositoryUpdateAttributes_574206, schemes: {Scheme.Https})
type
  Call_RepositoryDelete_574197 = ref object of OpenApiRestCall_573657
proc url_RepositoryDelete_574199(protocol: Scheme; host: string; base: string;
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

proc validate_RepositoryDelete_574198(path: JsonNode; query: JsonNode;
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

proc call*(call_574201: Call_RepositoryDelete_574197; path: JsonNode;
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

proc call*(call_574202: Call_RepositoryDelete_574197; name: string): Recallable =
  ## repositoryDelete
  ## Delete the repository identified by `name`
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  var path_574203 = newJObject()
  add(path_574203, "name", newJString(name))
  result = call_574202.call(path_574203, nil, nil, nil, nil)

var repositoryDelete* = Call_RepositoryDelete_574197(name: "repositoryDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/acr/v1/{name}",
    validator: validate_RepositoryDelete_574198, base: "",
    url: url_RepositoryDelete_574199, schemes: {Scheme.Https})
type
  Call_ManifestsGetList_574230 = ref object of OpenApiRestCall_573657
proc url_ManifestsGetList_574232(protocol: Scheme; host: string; base: string;
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

proc validate_ManifestsGetList_574231(path: JsonNode; query: JsonNode;
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

proc call*(call_574237: Call_ManifestsGetList_574230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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

proc call*(call_574238: Call_ManifestsGetList_574230; name: string;
          orderby: string = ""; last: string = ""; n: int = 0): Recallable =
  ## manifestsGetList
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

var manifestsGetList* = Call_ManifestsGetList_574230(name: "manifestsGetList",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}/_manifests", validator: validate_ManifestsGetList_574231,
    base: "", url: url_ManifestsGetList_574232, schemes: {Scheme.Https})
type
  Call_ManifestsGetAttributes_574241 = ref object of OpenApiRestCall_573657
proc url_ManifestsGetAttributes_574243(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/_manifests/"),
               (kind: VariableSegment, value: "reference")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManifestsGetAttributes_574242(path: JsonNode; query: JsonNode;
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

proc call*(call_574246: Call_ManifestsGetAttributes_574241; path: JsonNode;
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

proc call*(call_574247: Call_ManifestsGetAttributes_574241; name: string;
          reference: string): Recallable =
  ## manifestsGetAttributes
  ## Get manifest attributes
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_574248 = newJObject()
  add(path_574248, "name", newJString(name))
  add(path_574248, "reference", newJString(reference))
  result = call_574247.call(path_574248, nil, nil, nil, nil)

var manifestsGetAttributes* = Call_ManifestsGetAttributes_574241(
    name: "manifestsGetAttributes", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}/_manifests/{reference}",
    validator: validate_ManifestsGetAttributes_574242, base: "",
    url: url_ManifestsGetAttributes_574243, schemes: {Scheme.Https})
type
  Call_ManifestsUpdateAttributes_574249 = ref object of OpenApiRestCall_573657
proc url_ManifestsUpdateAttributes_574251(protocol: Scheme; host: string;
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

proc validate_ManifestsUpdateAttributes_574250(path: JsonNode; query: JsonNode;
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

proc call*(call_574255: Call_ManifestsUpdateAttributes_574249; path: JsonNode;
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

proc call*(call_574256: Call_ManifestsUpdateAttributes_574249; name: string;
          reference: string; value: JsonNode = nil): Recallable =
  ## manifestsUpdateAttributes
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

var manifestsUpdateAttributes* = Call_ManifestsUpdateAttributes_574249(
    name: "manifestsUpdateAttributes", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/acr/v1/{name}/_manifests/{reference}",
    validator: validate_ManifestsUpdateAttributes_574250, base: "",
    url: url_ManifestsUpdateAttributes_574251, schemes: {Scheme.Https})
type
  Call_TagGetList_574259 = ref object of OpenApiRestCall_573657
proc url_TagGetList_574261(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_TagGetList_574260(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_574267: Call_TagGetList_574259; path: JsonNode; query: JsonNode;
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

proc call*(call_574268: Call_TagGetList_574259; name: string; digest: string = "";
          orderby: string = ""; last: string = ""; n: int = 0): Recallable =
  ## tagGetList
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

var tagGetList* = Call_TagGetList_574259(name: "tagGetList",
                                      meth: HttpMethod.HttpGet,
                                      host: "azure.local",
                                      route: "/acr/v1/{name}/_tags",
                                      validator: validate_TagGetList_574260,
                                      base: "", url: url_TagGetList_574261,
                                      schemes: {Scheme.Https})
type
  Call_TagGetAttributes_574271 = ref object of OpenApiRestCall_573657
proc url_TagGetAttributes_574273(protocol: Scheme; host: string; base: string;
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

proc validate_TagGetAttributes_574272(path: JsonNode; query: JsonNode;
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
  ##            : Tag name
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

proc call*(call_574276: Call_TagGetAttributes_574271; path: JsonNode;
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

proc call*(call_574277: Call_TagGetAttributes_574271; name: string; reference: string): Recallable =
  ## tagGetAttributes
  ## Get tag attributes by tag
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : Tag name
  var path_574278 = newJObject()
  add(path_574278, "name", newJString(name))
  add(path_574278, "reference", newJString(reference))
  result = call_574277.call(path_574278, nil, nil, nil, nil)

var tagGetAttributes* = Call_TagGetAttributes_574271(name: "tagGetAttributes",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/acr/v1/{name}/_tags/{reference}",
    validator: validate_TagGetAttributes_574272, base: "",
    url: url_TagGetAttributes_574273, schemes: {Scheme.Https})
type
  Call_TagUpdateAttributes_574287 = ref object of OpenApiRestCall_573657
proc url_TagUpdateAttributes_574289(protocol: Scheme; host: string; base: string;
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

proc validate_TagUpdateAttributes_574288(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Update tag attributes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : Tag name
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

proc call*(call_574293: Call_TagUpdateAttributes_574287; path: JsonNode;
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

proc call*(call_574294: Call_TagUpdateAttributes_574287; name: string;
          reference: string; value: JsonNode = nil): Recallable =
  ## tagUpdateAttributes
  ## Update tag attributes
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : Tag name
  ##   value: JObject
  ##        : Repository attribute value
  var path_574295 = newJObject()
  var body_574296 = newJObject()
  add(path_574295, "name", newJString(name))
  add(path_574295, "reference", newJString(reference))
  if value != nil:
    body_574296 = value
  result = call_574294.call(path_574295, nil, nil, nil, body_574296)

var tagUpdateAttributes* = Call_TagUpdateAttributes_574287(
    name: "tagUpdateAttributes", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/acr/v1/{name}/_tags/{reference}",
    validator: validate_TagUpdateAttributes_574288, base: "",
    url: url_TagUpdateAttributes_574289, schemes: {Scheme.Https})
type
  Call_TagDelete_574279 = ref object of OpenApiRestCall_573657
proc url_TagDelete_574281(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
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

proc validate_TagDelete_574280(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete tag
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   reference: JString (required)
  ##            : Tag name
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

proc call*(call_574284: Call_TagDelete_574279; path: JsonNode; query: JsonNode;
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

proc call*(call_574285: Call_TagDelete_574279; name: string; reference: string): Recallable =
  ## tagDelete
  ## Delete tag
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : Tag name
  var path_574286 = newJObject()
  add(path_574286, "name", newJString(name))
  add(path_574286, "reference", newJString(reference))
  result = call_574285.call(path_574286, nil, nil, nil, nil)

var tagDelete* = Call_TagDelete_574279(name: "tagDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "azure.local",
                                    route: "/acr/v1/{name}/_tags/{reference}",
                                    validator: validate_TagDelete_574280,
                                    base: "", url: url_TagDelete_574281,
                                    schemes: {Scheme.Https})
type
  Call_RefreshTokensGetFromExchange_574297 = ref object of OpenApiRestCall_573657
proc url_RefreshTokensGetFromExchange_574299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RefreshTokensGetFromExchange_574298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_574318: Call_RefreshTokensGetFromExchange_574297; path: JsonNode;
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

proc call*(call_574319: Call_RefreshTokensGetFromExchange_574297; service: string;
          refreshToken: string = ""; tenant: string = "";
          grantType: string = "access_token_refresh_token"; accessToken: string = ""): Recallable =
  ## refreshTokensGetFromExchange
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

var refreshTokensGetFromExchange* = Call_RefreshTokensGetFromExchange_574297(
    name: "refreshTokensGetFromExchange", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/oauth2/exchange",
    validator: validate_RefreshTokensGetFromExchange_574298, base: "",
    url: url_RefreshTokensGetFromExchange_574299, schemes: {Scheme.Https})
type
  Call_AccessTokensGet_574329 = ref object of OpenApiRestCall_573657
proc url_AccessTokensGet_574331(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccessTokensGet_574330(path: JsonNode; query: JsonNode;
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

proc call*(call_574336: Call_AccessTokensGet_574329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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

proc call*(call_574337: Call_AccessTokensGet_574329; scope: string;
          refreshToken: string; service: string; grantType: string = "refresh_token"): Recallable =
  ## accessTokensGet
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

var accessTokensGet* = Call_AccessTokensGet_574329(name: "accessTokensGet",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/oauth2/token",
    validator: validate_AccessTokensGet_574330, base: "", url: url_AccessTokensGet_574331,
    schemes: {Scheme.Https})
type
  Call_AccessTokensGetFromLogin_574321 = ref object of OpenApiRestCall_573657
proc url_AccessTokensGetFromLogin_574323(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccessTokensGetFromLogin_574322(path: JsonNode; query: JsonNode;
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

proc call*(call_574326: Call_AccessTokensGetFromLogin_574321; path: JsonNode;
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

proc call*(call_574327: Call_AccessTokensGetFromLogin_574321; service: string;
          scope: string): Recallable =
  ## accessTokensGetFromLogin
  ## Exchange Username, Password and Scope an ACR Access Token
  ##   service: string (required)
  ##          : Indicates the name of your Azure container registry.
  ##   scope: string (required)
  ##        : Expected to be a valid scope, and can be specified more than once for multiple scope requests. You can obtain this from the Www-Authenticate response header from the challenge.
  var query_574328 = newJObject()
  add(query_574328, "service", newJString(service))
  add(query_574328, "scope", newJString(scope))
  result = call_574327.call(nil, query_574328, nil, nil, nil)

var accessTokensGetFromLogin* = Call_AccessTokensGetFromLogin_574321(
    name: "accessTokensGetFromLogin", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/oauth2/token", validator: validate_AccessTokensGetFromLogin_574322,
    base: "", url: url_AccessTokensGetFromLogin_574323, schemes: {Scheme.Https})
type
  Call_V2SupportCheck_574339 = ref object of OpenApiRestCall_573657
proc url_V2SupportCheck_574341(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_V2SupportCheck_574340(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
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

proc call*(call_574342: Call_V2SupportCheck_574339; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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

proc call*(call_574343: Call_V2SupportCheck_574339): Recallable =
  ## v2SupportCheck
  ## Tells whether this Docker Registry instance supports Docker Registry HTTP API v2
  result = call_574343.call(nil, nil, nil, nil, nil)

var v2SupportCheck* = Call_V2SupportCheck_574339(name: "v2SupportCheck",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/v2/",
    validator: validate_V2SupportCheck_574340, base: "", url: url_V2SupportCheck_574341,
    schemes: {Scheme.Https})
type
  Call_BlobMount_574344 = ref object of OpenApiRestCall_573657
proc url_BlobMount_574346(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/blobs/uploads/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobMount_574345(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Mount a blob identified by the `mount` parameter from another repository.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574347 = path.getOrDefault("name")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "name", valid_574347
  result.add "path", section
  ## parameters in `query` object:
  ##   from: JString (required)
  ##       : Name of the source repository.
  ##   mount: JString (required)
  ##        : Digest of blob to mount from the source repository.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `from` field"
  var valid_574348 = query.getOrDefault("from")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "from", valid_574348
  var valid_574349 = query.getOrDefault("mount")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "mount", valid_574349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574350: Call_BlobMount_574344; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Mount a blob identified by the `mount` parameter from another repository.
  ## 
  let valid = call_574350.validator(path, query, header, formData, body)
  let scheme = call_574350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574350.url(scheme.get, call_574350.host, call_574350.base,
                         call_574350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574350, url, valid)

proc call*(call_574351: Call_BlobMount_574344; name: string; `from`: string;
          mount: string): Recallable =
  ## blobMount
  ## Mount a blob identified by the `mount` parameter from another repository.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   from: string (required)
  ##       : Name of the source repository.
  ##   mount: string (required)
  ##        : Digest of blob to mount from the source repository.
  var path_574352 = newJObject()
  var query_574353 = newJObject()
  add(path_574352, "name", newJString(name))
  add(query_574353, "from", newJString(`from`))
  add(query_574353, "mount", newJString(mount))
  result = call_574351.call(path_574352, query_574353, nil, nil, nil)

var blobMount* = Call_BlobMount_574344(name: "blobMount", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/v2/{name}/blobs/uploads/",
                                    validator: validate_BlobMount_574345,
                                    base: "", url: url_BlobMount_574346,
                                    schemes: {Scheme.Https})
type
  Call_BlobCheck_574370 = ref object of OpenApiRestCall_573657
proc url_BlobCheck_574372(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "digest" in path, "`digest` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/blobs/"),
               (kind: VariableSegment, value: "digest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobCheck_574371(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Same as GET, except only the headers are returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   digest: JString (required)
  ##         : Digest of a BLOB
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574373 = path.getOrDefault("name")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "name", valid_574373
  var valid_574374 = path.getOrDefault("digest")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "digest", valid_574374
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574375: Call_BlobCheck_574370; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Same as GET, except only the headers are returned.
  ## 
  let valid = call_574375.validator(path, query, header, formData, body)
  let scheme = call_574375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574375.url(scheme.get, call_574375.host, call_574375.base,
                         call_574375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574375, url, valid)

proc call*(call_574376: Call_BlobCheck_574370; name: string; digest: string): Recallable =
  ## blobCheck
  ## Same as GET, except only the headers are returned.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   digest: string (required)
  ##         : Digest of a BLOB
  var path_574377 = newJObject()
  add(path_574377, "name", newJString(name))
  add(path_574377, "digest", newJString(digest))
  result = call_574376.call(path_574377, nil, nil, nil, nil)

var blobCheck* = Call_BlobCheck_574370(name: "blobCheck", meth: HttpMethod.HttpHead,
                                    host: "azure.local",
                                    route: "/v2/{name}/blobs/{digest}",
                                    validator: validate_BlobCheck_574371,
                                    base: "", url: url_BlobCheck_574372,
                                    schemes: {Scheme.Https})
type
  Call_BlobGet_574354 = ref object of OpenApiRestCall_573657
proc url_BlobGet_574356(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "digest" in path, "`digest` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/blobs/"),
               (kind: VariableSegment, value: "digest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobGet_574355(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the blob from the registry identified by digest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   digest: JString (required)
  ##         : Digest of a BLOB
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574357 = path.getOrDefault("name")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "name", valid_574357
  var valid_574358 = path.getOrDefault("digest")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "digest", valid_574358
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574359: Call_BlobGet_574354; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the blob from the registry identified by digest.
  ## 
  let valid = call_574359.validator(path, query, header, formData, body)
  let scheme = call_574359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574359.url(scheme.get, call_574359.host, call_574359.base,
                         call_574359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574359, url, valid)

proc call*(call_574360: Call_BlobGet_574354; name: string; digest: string): Recallable =
  ## blobGet
  ## Retrieve the blob from the registry identified by digest.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   digest: string (required)
  ##         : Digest of a BLOB
  var path_574361 = newJObject()
  add(path_574361, "name", newJString(name))
  add(path_574361, "digest", newJString(digest))
  result = call_574360.call(path_574361, nil, nil, nil, nil)

var blobGet* = Call_BlobGet_574354(name: "blobGet", meth: HttpMethod.HttpGet,
                                host: "azure.local",
                                route: "/v2/{name}/blobs/{digest}",
                                validator: validate_BlobGet_574355, base: "",
                                url: url_BlobGet_574356, schemes: {Scheme.Https})
type
  Call_BlobDelete_574362 = ref object of OpenApiRestCall_573657
proc url_BlobDelete_574364(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  assert "digest" in path, "`digest` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/blobs/"),
               (kind: VariableSegment, value: "digest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobDelete_574363(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an already uploaded blob.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the image (including the namespace)
  ##   digest: JString (required)
  ##         : Digest of a BLOB
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574365 = path.getOrDefault("name")
  valid_574365 = validateParameter(valid_574365, JString, required = true,
                                 default = nil)
  if valid_574365 != nil:
    section.add "name", valid_574365
  var valid_574366 = path.getOrDefault("digest")
  valid_574366 = validateParameter(valid_574366, JString, required = true,
                                 default = nil)
  if valid_574366 != nil:
    section.add "digest", valid_574366
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574367: Call_BlobDelete_574362; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an already uploaded blob.
  ## 
  let valid = call_574367.validator(path, query, header, formData, body)
  let scheme = call_574367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574367.url(scheme.get, call_574367.host, call_574367.base,
                         call_574367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574367, url, valid)

proc call*(call_574368: Call_BlobDelete_574362; name: string; digest: string): Recallable =
  ## blobDelete
  ## Removes an already uploaded blob.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   digest: string (required)
  ##         : Digest of a BLOB
  var path_574369 = newJObject()
  add(path_574369, "name", newJString(name))
  add(path_574369, "digest", newJString(digest))
  result = call_574368.call(path_574369, nil, nil, nil, nil)

var blobDelete* = Call_BlobDelete_574362(name: "blobDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/v2/{name}/blobs/{digest}",
                                      validator: validate_BlobDelete_574363,
                                      base: "", url: url_BlobDelete_574364,
                                      schemes: {Scheme.Https})
type
  Call_ManifestsCreate_574387 = ref object of OpenApiRestCall_573657
proc url_ManifestsCreate_574389(protocol: Scheme; host: string; base: string;
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

proc validate_ManifestsCreate_574388(path: JsonNode; query: JsonNode;
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
  var valid_574390 = path.getOrDefault("name")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "name", valid_574390
  var valid_574391 = path.getOrDefault("reference")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "reference", valid_574391
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

proc call*(call_574393: Call_ManifestsCreate_574387; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Put the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
  ## 
  let valid = call_574393.validator(path, query, header, formData, body)
  let scheme = call_574393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574393.url(scheme.get, call_574393.host, call_574393.base,
                         call_574393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574393, url, valid)

proc call*(call_574394: Call_ManifestsCreate_574387; name: string; reference: string;
          payload: JsonNode): Recallable =
  ## manifestsCreate
  ## Put the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  ##   payload: JObject (required)
  ##          : Manifest body, can take v1 or v2 values depending on accept header
  var path_574395 = newJObject()
  var body_574396 = newJObject()
  add(path_574395, "name", newJString(name))
  add(path_574395, "reference", newJString(reference))
  if payload != nil:
    body_574396 = payload
  result = call_574394.call(path_574395, nil, nil, nil, body_574396)

var manifestsCreate* = Call_ManifestsCreate_574387(name: "manifestsCreate",
    meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/v2/{name}/manifests/{reference}",
    validator: validate_ManifestsCreate_574388, base: "", url: url_ManifestsCreate_574389,
    schemes: {Scheme.Https})
type
  Call_ManifestsGet_574378 = ref object of OpenApiRestCall_573657
proc url_ManifestsGet_574380(protocol: Scheme; host: string; base: string;
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

proc validate_ManifestsGet_574379(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
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
  var valid_574381 = path.getOrDefault("name")
  valid_574381 = validateParameter(valid_574381, JString, required = true,
                                 default = nil)
  if valid_574381 != nil:
    section.add "name", valid_574381
  var valid_574382 = path.getOrDefault("reference")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "reference", valid_574382
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   accept: JString
  ##         : Accept header string delimited by comma. For example, application/vnd.docker.distribution.manifest.v2+json
  section = newJObject()
  var valid_574383 = header.getOrDefault("accept")
  valid_574383 = validateParameter(valid_574383, JString, required = false,
                                 default = nil)
  if valid_574383 != nil:
    section.add "accept", valid_574383
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574384: Call_ManifestsGet_574378; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
  ## 
  let valid = call_574384.validator(path, query, header, formData, body)
  let scheme = call_574384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574384.url(scheme.get, call_574384.host, call_574384.base,
                         call_574384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574384, url, valid)

proc call*(call_574385: Call_ManifestsGet_574378; name: string; reference: string): Recallable =
  ## manifestsGet
  ## Get the manifest identified by `name` and `reference` where `reference` can be a tag or digest.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_574386 = newJObject()
  add(path_574386, "name", newJString(name))
  add(path_574386, "reference", newJString(reference))
  result = call_574385.call(path_574386, nil, nil, nil, nil)

var manifestsGet* = Call_ManifestsGet_574378(name: "manifestsGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/v2/{name}/manifests/{reference}", validator: validate_ManifestsGet_574379,
    base: "", url: url_ManifestsGet_574380, schemes: {Scheme.Https})
type
  Call_ManifestsDelete_574397 = ref object of OpenApiRestCall_573657
proc url_ManifestsDelete_574399(protocol: Scheme; host: string; base: string;
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

proc validate_ManifestsDelete_574398(path: JsonNode; query: JsonNode;
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
  var valid_574400 = path.getOrDefault("name")
  valid_574400 = validateParameter(valid_574400, JString, required = true,
                                 default = nil)
  if valid_574400 != nil:
    section.add "name", valid_574400
  var valid_574401 = path.getOrDefault("reference")
  valid_574401 = validateParameter(valid_574401, JString, required = true,
                                 default = nil)
  if valid_574401 != nil:
    section.add "reference", valid_574401
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574402: Call_ManifestsDelete_574397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the manifest identified by `name` and `reference`. Note that a manifest can _only_ be deleted by `digest`.
  ## 
  let valid = call_574402.validator(path, query, header, formData, body)
  let scheme = call_574402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574402.url(scheme.get, call_574402.host, call_574402.base,
                         call_574402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574402, url, valid)

proc call*(call_574403: Call_ManifestsDelete_574397; name: string; reference: string): Recallable =
  ## manifestsDelete
  ## Delete the manifest identified by `name` and `reference`. Note that a manifest can _only_ be deleted by `digest`.
  ##   name: string (required)
  ##       : Name of the image (including the namespace)
  ##   reference: string (required)
  ##            : A tag or a digest, pointing to a specific image
  var path_574404 = newJObject()
  add(path_574404, "name", newJString(name))
  add(path_574404, "reference", newJString(reference))
  result = call_574403.call(path_574404, nil, nil, nil, nil)

var manifestsDelete* = Call_ManifestsDelete_574397(name: "manifestsDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/v2/{name}/manifests/{reference}",
    validator: validate_ManifestsDelete_574398, base: "", url: url_ManifestsDelete_574399,
    schemes: {Scheme.Https})
type
  Call_BlobEndUpload_574412 = ref object of OpenApiRestCall_573657
proc url_BlobEndUpload_574414(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nextBlobUuidLink" in path,
        "`nextBlobUuidLink` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "nextBlobUuidLink")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobEndUpload_574413(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Complete the upload, providing all the data in the body, if necessary. A request without a body will just complete the upload with previously uploaded content.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nextBlobUuidLink: JString (required)
  ##                   : Link acquired from upload start or previous chunk. Note, do not include initial / (must do substring(1) )
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `nextBlobUuidLink` field"
  var valid_574415 = path.getOrDefault("nextBlobUuidLink")
  valid_574415 = validateParameter(valid_574415, JString, required = true,
                                 default = nil)
  if valid_574415 != nil:
    section.add "nextBlobUuidLink", valid_574415
  result.add "path", section
  ## parameters in `query` object:
  ##   digest: JString (required)
  ##         : Digest of a BLOB
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `digest` field"
  var valid_574416 = query.getOrDefault("digest")
  valid_574416 = validateParameter(valid_574416, JString, required = true,
                                 default = nil)
  if valid_574416 != nil:
    section.add "digest", valid_574416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   value: JObject
  ##        : Optional raw data of blob
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574418: Call_BlobEndUpload_574412; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Complete the upload, providing all the data in the body, if necessary. A request without a body will just complete the upload with previously uploaded content.
  ## 
  let valid = call_574418.validator(path, query, header, formData, body)
  let scheme = call_574418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574418.url(scheme.get, call_574418.host, call_574418.base,
                         call_574418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574418, url, valid)

proc call*(call_574419: Call_BlobEndUpload_574412; digest: string;
          nextBlobUuidLink: string; value: JsonNode = nil): Recallable =
  ## blobEndUpload
  ## Complete the upload, providing all the data in the body, if necessary. A request without a body will just complete the upload with previously uploaded content.
  ##   digest: string (required)
  ##         : Digest of a BLOB
  ##   value: JObject
  ##        : Optional raw data of blob
  ##   nextBlobUuidLink: string (required)
  ##                   : Link acquired from upload start or previous chunk. Note, do not include initial / (must do substring(1) )
  var path_574420 = newJObject()
  var query_574421 = newJObject()
  var body_574422 = newJObject()
  add(query_574421, "digest", newJString(digest))
  if value != nil:
    body_574422 = value
  add(path_574420, "nextBlobUuidLink", newJString(nextBlobUuidLink))
  result = call_574419.call(path_574420, query_574421, nil, nil, body_574422)

var blobEndUpload* = Call_BlobEndUpload_574412(name: "blobEndUpload",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/{nextBlobUuidLink}",
    validator: validate_BlobEndUpload_574413, base: "", url: url_BlobEndUpload_574414,
    schemes: {Scheme.Https})
type
  Call_BlobGetStatus_574405 = ref object of OpenApiRestCall_573657
proc url_BlobGetStatus_574407(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nextBlobUuidLink" in path,
        "`nextBlobUuidLink` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "nextBlobUuidLink")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobGetStatus_574406(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve status of upload identified by uuid. The primary purpose of this endpoint is to resolve the current status of a resumable upload.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nextBlobUuidLink: JString (required)
  ##                   : Link acquired from upload start or previous chunk. Note, do not include initial / (must do substring(1) )
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `nextBlobUuidLink` field"
  var valid_574408 = path.getOrDefault("nextBlobUuidLink")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "nextBlobUuidLink", valid_574408
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574409: Call_BlobGetStatus_574405; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve status of upload identified by uuid. The primary purpose of this endpoint is to resolve the current status of a resumable upload.
  ## 
  let valid = call_574409.validator(path, query, header, formData, body)
  let scheme = call_574409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574409.url(scheme.get, call_574409.host, call_574409.base,
                         call_574409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574409, url, valid)

proc call*(call_574410: Call_BlobGetStatus_574405; nextBlobUuidLink: string): Recallable =
  ## blobGetStatus
  ## Retrieve status of upload identified by uuid. The primary purpose of this endpoint is to resolve the current status of a resumable upload.
  ##   nextBlobUuidLink: string (required)
  ##                   : Link acquired from upload start or previous chunk. Note, do not include initial / (must do substring(1) )
  var path_574411 = newJObject()
  add(path_574411, "nextBlobUuidLink", newJString(nextBlobUuidLink))
  result = call_574410.call(path_574411, nil, nil, nil, nil)

var blobGetStatus* = Call_BlobGetStatus_574405(name: "blobGetStatus",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/{nextBlobUuidLink}",
    validator: validate_BlobGetStatus_574406, base: "", url: url_BlobGetStatus_574407,
    schemes: {Scheme.Https})
type
  Call_BlobUpload_574430 = ref object of OpenApiRestCall_573657
proc url_BlobUpload_574432(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nextBlobUuidLink" in path,
        "`nextBlobUuidLink` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "nextBlobUuidLink")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobUpload_574431(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload a stream of data without completing the upload.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nextBlobUuidLink: JString (required)
  ##                   : Link acquired from upload start or previous chunk. Note, do not include initial / (must do substring(1) )
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `nextBlobUuidLink` field"
  var valid_574433 = path.getOrDefault("nextBlobUuidLink")
  valid_574433 = validateParameter(valid_574433, JString, required = true,
                                 default = nil)
  if valid_574433 != nil:
    section.add "nextBlobUuidLink", valid_574433
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   value: JObject (required)
  ##        : Raw data of blob
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574435: Call_BlobUpload_574430; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upload a stream of data without completing the upload.
  ## 
  let valid = call_574435.validator(path, query, header, formData, body)
  let scheme = call_574435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574435.url(scheme.get, call_574435.host, call_574435.base,
                         call_574435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574435, url, valid)

proc call*(call_574436: Call_BlobUpload_574430; value: JsonNode;
          nextBlobUuidLink: string): Recallable =
  ## blobUpload
  ## Upload a stream of data without completing the upload.
  ##   value: JObject (required)
  ##        : Raw data of blob
  ##   nextBlobUuidLink: string (required)
  ##                   : Link acquired from upload start or previous chunk. Note, do not include initial / (must do substring(1) )
  var path_574437 = newJObject()
  var body_574438 = newJObject()
  if value != nil:
    body_574438 = value
  add(path_574437, "nextBlobUuidLink", newJString(nextBlobUuidLink))
  result = call_574436.call(path_574437, nil, nil, nil, body_574438)

var blobUpload* = Call_BlobUpload_574430(name: "blobUpload",
                                      meth: HttpMethod.HttpPatch,
                                      host: "azure.local",
                                      route: "/{nextBlobUuidLink}",
                                      validator: validate_BlobUpload_574431,
                                      base: "", url: url_BlobUpload_574432,
                                      schemes: {Scheme.Https})
type
  Call_BlobCancelUpload_574423 = ref object of OpenApiRestCall_573657
proc url_BlobCancelUpload_574425(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nextBlobUuidLink" in path,
        "`nextBlobUuidLink` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "nextBlobUuidLink")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobCancelUpload_574424(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Cancel outstanding upload processes, releasing associated resources. If this is not called, the unfinished uploads will eventually timeout.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nextBlobUuidLink: JString (required)
  ##                   : Link acquired from upload start or previous chunk. Note, do not include initial / (must do substring(1) )
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `nextBlobUuidLink` field"
  var valid_574426 = path.getOrDefault("nextBlobUuidLink")
  valid_574426 = validateParameter(valid_574426, JString, required = true,
                                 default = nil)
  if valid_574426 != nil:
    section.add "nextBlobUuidLink", valid_574426
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574427: Call_BlobCancelUpload_574423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel outstanding upload processes, releasing associated resources. If this is not called, the unfinished uploads will eventually timeout.
  ## 
  let valid = call_574427.validator(path, query, header, formData, body)
  let scheme = call_574427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574427.url(scheme.get, call_574427.host, call_574427.base,
                         call_574427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574427, url, valid)

proc call*(call_574428: Call_BlobCancelUpload_574423; nextBlobUuidLink: string): Recallable =
  ## blobCancelUpload
  ## Cancel outstanding upload processes, releasing associated resources. If this is not called, the unfinished uploads will eventually timeout.
  ##   nextBlobUuidLink: string (required)
  ##                   : Link acquired from upload start or previous chunk. Note, do not include initial / (must do substring(1) )
  var path_574429 = newJObject()
  add(path_574429, "nextBlobUuidLink", newJString(nextBlobUuidLink))
  result = call_574428.call(path_574429, nil, nil, nil, nil)

var blobCancelUpload* = Call_BlobCancelUpload_574423(name: "blobCancelUpload",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/{nextBlobUuidLink}",
    validator: validate_BlobCancelUpload_574424, base: "",
    url: url_BlobCancelUpload_574425, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
