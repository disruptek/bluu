
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on tenant entity associated with your Azure API Management deployment. Using this entity you can manage properties and configuration that apply to the entire API Management service instance.
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  macServiceName = "apimanagement-apimtenant"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TenantAccessGet_593630 = ref object of OpenApiRestCall_593408
proc url_TenantAccessGet_593632(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGet_593631(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get tenant access information details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_593818 = path.getOrDefault("accessName")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = newJString("access"))
  if valid_593818 != nil:
    section.add "accessName", valid_593818
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593819 = query.getOrDefault("api-version")
  valid_593819 = validateParameter(valid_593819, JString, required = true,
                                 default = nil)
  if valid_593819 != nil:
    section.add "api-version", valid_593819
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593842: Call_TenantAccessGet_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tenant access information details.
  ## 
  let valid = call_593842.validator(path, query, header, formData, body)
  let scheme = call_593842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593842.url(scheme.get, call_593842.host, call_593842.base,
                         call_593842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593842, url, valid)

proc call*(call_593913: Call_TenantAccessGet_593630; apiVersion: string;
          accessName: string = "access"): Recallable =
  ## tenantAccessGet
  ## Get tenant access information details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_593914 = newJObject()
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  add(path_593914, "accessName", newJString(accessName))
  result = call_593913.call(path_593914, query_593916, nil, nil, nil)

var tenantAccessGet* = Call_TenantAccessGet_593630(name: "tenantAccessGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/tenant/{accessName}",
    validator: validate_TenantAccessGet_593631, base: "", url: url_TenantAccessGet_593632,
    schemes: {Scheme.Https})
type
  Call_TenantAccessUpdate_593955 = ref object of OpenApiRestCall_593408
proc url_TenantAccessUpdate_593957(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessUpdate_593956(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update tenant access information details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_593975 = path.getOrDefault("accessName")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = newJString("access"))
  if valid_593975 != nil:
    section.add "accessName", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the property to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_593977 = header.getOrDefault("If-Match")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "If-Match", valid_593977
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to retrieve the Tenant Access Information.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_TenantAccessUpdate_593955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update tenant access information details.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_TenantAccessUpdate_593955; apiVersion: string;
          parameters: JsonNode; accessName: string = "access"): Recallable =
  ## tenantAccessUpdate
  ## Update tenant access information details.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to retrieve the Tenant Access Information.
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  var body_593983 = newJObject()
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "accessName", newJString(accessName))
  if parameters != nil:
    body_593983 = parameters
  result = call_593980.call(path_593981, query_593982, nil, nil, body_593983)

var tenantAccessUpdate* = Call_TenantAccessUpdate_593955(
    name: "tenantAccessUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/tenant/{accessName}", validator: validate_TenantAccessUpdate_593956,
    base: "", url: url_TenantAccessUpdate_593957, schemes: {Scheme.Https})
type
  Call_TenantAccessGitGet_593984 = ref object of OpenApiRestCall_593408
proc url_TenantAccessGitGet_593986(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/git")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitGet_593985(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the Git access configuration for the tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_593987 = path.getOrDefault("accessName")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = newJString("access"))
  if valid_593987 != nil:
    section.add "accessName", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_TenantAccessGitGet_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Git access configuration for the tenant.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_TenantAccessGitGet_593984; apiVersion: string;
          accessName: string = "access"): Recallable =
  ## tenantAccessGitGet
  ## Gets the Git access configuration for the tenant.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "accessName", newJString(accessName))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var tenantAccessGitGet* = Call_TenantAccessGitGet_593984(
    name: "tenantAccessGitGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/tenant/{accessName}/git", validator: validate_TenantAccessGitGet_593985,
    base: "", url: url_TenantAccessGitGet_593986, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegeneratePrimaryKey_593993 = ref object of OpenApiRestCall_593408
proc url_TenantAccessGitRegeneratePrimaryKey_593995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/git/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegeneratePrimaryKey_593994(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_593996 = path.getOrDefault("accessName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = newJString("access"))
  if valid_593996 != nil:
    section.add "accessName", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_TenantAccessGitRegeneratePrimaryKey_593993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key for GIT.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_TenantAccessGitRegeneratePrimaryKey_593993;
          apiVersion: string; accessName: string = "access"): Recallable =
  ## tenantAccessGitRegeneratePrimaryKey
  ## Regenerate primary access key for GIT.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "accessName", newJString(accessName))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var tenantAccessGitRegeneratePrimaryKey* = Call_TenantAccessGitRegeneratePrimaryKey_593993(
    name: "tenantAccessGitRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{accessName}/git/regeneratePrimaryKey",
    validator: validate_TenantAccessGitRegeneratePrimaryKey_593994, base: "",
    url: url_TenantAccessGitRegeneratePrimaryKey_593995, schemes: {Scheme.Https})
type
  Call_TenantAccessGitRegenerateSecondaryKey_594002 = ref object of OpenApiRestCall_593408
proc url_TenantAccessGitRegenerateSecondaryKey_594004(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/git/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessGitRegenerateSecondaryKey_594003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key for GIT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_594005 = path.getOrDefault("accessName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = newJString("access"))
  if valid_594005 != nil:
    section.add "accessName", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_TenantAccessGitRegenerateSecondaryKey_594002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key for GIT.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_TenantAccessGitRegenerateSecondaryKey_594002;
          apiVersion: string; accessName: string = "access"): Recallable =
  ## tenantAccessGitRegenerateSecondaryKey
  ## Regenerate secondary access key for GIT.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "accessName", newJString(accessName))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var tenantAccessGitRegenerateSecondaryKey* = Call_TenantAccessGitRegenerateSecondaryKey_594002(
    name: "tenantAccessGitRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{accessName}/git/regenerateSecondaryKey",
    validator: validate_TenantAccessGitRegenerateSecondaryKey_594003, base: "",
    url: url_TenantAccessGitRegenerateSecondaryKey_594004, schemes: {Scheme.Https})
type
  Call_TenantAccessRegeneratePrimaryKey_594011 = ref object of OpenApiRestCall_593408
proc url_TenantAccessRegeneratePrimaryKey_594013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegeneratePrimaryKey_594012(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate primary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_594014 = path.getOrDefault("accessName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = newJString("access"))
  if valid_594014 != nil:
    section.add "accessName", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_TenantAccessRegeneratePrimaryKey_594011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate primary access key.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_TenantAccessRegeneratePrimaryKey_594011;
          apiVersion: string; accessName: string = "access"): Recallable =
  ## tenantAccessRegeneratePrimaryKey
  ## Regenerate primary access key.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(query_594019, "api-version", newJString(apiVersion))
  add(path_594018, "accessName", newJString(accessName))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var tenantAccessRegeneratePrimaryKey* = Call_TenantAccessRegeneratePrimaryKey_594011(
    name: "tenantAccessRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{accessName}/regeneratePrimaryKey",
    validator: validate_TenantAccessRegeneratePrimaryKey_594012, base: "",
    url: url_TenantAccessRegeneratePrimaryKey_594013, schemes: {Scheme.Https})
type
  Call_TenantAccessRegenerateSecondaryKey_594020 = ref object of OpenApiRestCall_593408
proc url_TenantAccessRegenerateSecondaryKey_594022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accessName" in path, "`accessName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "accessName"),
               (kind: ConstantSegment, value: "/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantAccessRegenerateSecondaryKey_594021(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerate secondary access key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accessName: JString (required)
  ##             : The identifier of the Access configuration.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `accessName` field"
  var valid_594023 = path.getOrDefault("accessName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = newJString("access"))
  if valid_594023 != nil:
    section.add "accessName", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_TenantAccessRegenerateSecondaryKey_594020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerate secondary access key.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_TenantAccessRegenerateSecondaryKey_594020;
          apiVersion: string; accessName: string = "access"): Recallable =
  ## tenantAccessRegenerateSecondaryKey
  ## Regenerate secondary access key.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   accessName: string (required)
  ##             : The identifier of the Access configuration.
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "accessName", newJString(accessName))
  result = call_594026.call(path_594027, query_594028, nil, nil, nil)

var tenantAccessRegenerateSecondaryKey* = Call_TenantAccessRegenerateSecondaryKey_594020(
    name: "tenantAccessRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{accessName}/regenerateSecondaryKey",
    validator: validate_TenantAccessRegenerateSecondaryKey_594021, base: "",
    url: url_TenantAccessRegenerateSecondaryKey_594022, schemes: {Scheme.Https})
type
  Call_TenantConfigurationDeploy_594029 = ref object of OpenApiRestCall_593408
proc url_TenantConfigurationDeploy_594031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/deploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationDeploy_594030(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configurationName` field"
  var valid_594032 = path.getOrDefault("configurationName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = newJString("configuration"))
  if valid_594032 != nil:
    section.add "configurationName", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_TenantConfigurationDeploy_594029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## 
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_TenantConfigurationDeploy_594029; apiVersion: string;
          parameters: JsonNode; configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationDeploy
  ## This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.
  ## To deploy any service configuration changes to the API Management service instance
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-deploy-any-service-configuration-changes-to-the-api-management-service-instance
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   parameters: JObject (required)
  ##             : Deploy Configuration parameters.
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  var body_594039 = newJObject()
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_594039 = parameters
  result = call_594036.call(path_594037, query_594038, nil, nil, body_594039)

var tenantConfigurationDeploy* = Call_TenantConfigurationDeploy_594029(
    name: "tenantConfigurationDeploy", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{configurationName}/deploy",
    validator: validate_TenantConfigurationDeploy_594030, base: "",
    url: url_TenantConfigurationDeploy_594031, schemes: {Scheme.Https})
type
  Call_TenantConfigurationSave_594040 = ref object of OpenApiRestCall_593408
proc url_TenantConfigurationSave_594042(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/save")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationSave_594041(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configurationName` field"
  var valid_594043 = path.getOrDefault("configurationName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = newJString("configuration"))
  if valid_594043 != nil:
    section.add "configurationName", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_TenantConfigurationSave_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## 
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_TenantConfigurationSave_594040; apiVersion: string;
          parameters: JsonNode; configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationSave
  ## This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.
  ## To save the service configuration to the Git repository
  ## https://azure.microsoft.com/en-us/documentation/articles/api-management-configuration-repository-git/#to-save-the-service-configuration-to-the-git-repository
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   parameters: JObject (required)
  ##             : Save Configuration parameters.
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  var body_594050 = newJObject()
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_594050 = parameters
  result = call_594047.call(path_594048, query_594049, nil, nil, body_594050)

var tenantConfigurationSave* = Call_TenantConfigurationSave_594040(
    name: "tenantConfigurationSave", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/tenant/{configurationName}/save",
    validator: validate_TenantConfigurationSave_594041, base: "",
    url: url_TenantConfigurationSave_594042, schemes: {Scheme.Https})
type
  Call_TenantConfigurationGetSyncState_594051 = ref object of OpenApiRestCall_593408
proc url_TenantConfigurationGetSyncState_594053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/syncState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationGetSyncState_594052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configurationName` field"
  var valid_594054 = path.getOrDefault("configurationName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = newJString("configuration"))
  if valid_594054 != nil:
    section.add "configurationName", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "api-version", valid_594055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_TenantConfigurationGetSyncState_594051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_TenantConfigurationGetSyncState_594051;
          apiVersion: string; configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationGetSyncState
  ## Gets the status of the most recent synchronization between the configuration database and the Git repository.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  add(query_594059, "api-version", newJString(apiVersion))
  add(path_594058, "configurationName", newJString(configurationName))
  result = call_594057.call(path_594058, query_594059, nil, nil, nil)

var tenantConfigurationGetSyncState* = Call_TenantConfigurationGetSyncState_594051(
    name: "tenantConfigurationGetSyncState", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/tenant/{configurationName}/syncState",
    validator: validate_TenantConfigurationGetSyncState_594052, base: "",
    url: url_TenantConfigurationGetSyncState_594053, schemes: {Scheme.Https})
type
  Call_TenantConfigurationValidate_594060 = ref object of OpenApiRestCall_593408
proc url_TenantConfigurationValidate_594062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "configurationName" in path,
        "`configurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tenant/"),
               (kind: VariableSegment, value: "configurationName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TenantConfigurationValidate_594061(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configurationName: JString (required)
  ##                    : The identifier of the Git Configuration Operation.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configurationName` field"
  var valid_594063 = path.getOrDefault("configurationName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = newJString("configuration"))
  if valid_594063 != nil:
    section.add "configurationName", valid_594063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Validate Configuration parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_TenantConfigurationValidate_594060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_TenantConfigurationValidate_594060;
          apiVersion: string; parameters: JsonNode;
          configurationName: string = "configuration"): Recallable =
  ## tenantConfigurationValidate
  ## This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   configurationName: string (required)
  ##                    : The identifier of the Git Configuration Operation.
  ##   parameters: JObject (required)
  ##             : Validate Configuration parameters.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  var body_594070 = newJObject()
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "configurationName", newJString(configurationName))
  if parameters != nil:
    body_594070 = parameters
  result = call_594067.call(path_594068, query_594069, nil, nil, body_594070)

var tenantConfigurationValidate* = Call_TenantConfigurationValidate_594060(
    name: "tenantConfigurationValidate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/tenant/{configurationName}/validate",
    validator: validate_TenantConfigurationValidate_594061, base: "",
    url: url_TenantConfigurationValidate_594062, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
