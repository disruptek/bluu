
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Migrate Hub
## version: 2018-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Migrate your workloads to Azure.
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "migrateprojects-migrate"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593660 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593662(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593661(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
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

proc call*(call_593767: Call_OperationsList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  ## 
  let valid = call_593767.validator(path, query, header, formData, body)
  let scheme = call_593767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593767.url(scheme.get, call_593767.host, call_593767.base,
                         call_593767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593767, url, valid)

proc call*(call_593851: Call_OperationsList_593660): Recallable =
  ## operationsList
  ## Get a list of REST API supported by Microsoft.Migrate provider.
  result = call_593851.call(nil, nil, nil, nil, nil)

var operationsList* = Call_OperationsList_593660(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Migrate/operations",
    validator: validate_OperationsList_593661, base: "", url: url_OperationsList_593662,
    schemes: {Scheme.Https})
type
  Call_MigrateProjectsPutMigrateProject_593992 = ref object of OpenApiRestCall_593438
proc url_MigrateProjectsPutMigrateProject_593994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsPutMigrateProject_593993(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("migrateProjectName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "migrateProjectName", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_593999 = header.getOrDefault("Accept-Language")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "Accept-Language", valid_593999
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_MigrateProjectsPutMigrateProject_593992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_MigrateProjectsPutMigrateProject_593992;
          resourceGroupName: string; subscriptionId: string; body: JsonNode;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsPutMigrateProject
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(path_594003, "resourceGroupName", newJString(resourceGroupName))
  add(query_594004, "api-version", newJString(apiVersion))
  add(path_594003, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_594005 = body
  add(path_594003, "migrateProjectName", newJString(migrateProjectName))
  result = call_594002.call(path_594003, query_594004, nil, nil, body_594005)

var migrateProjectsPutMigrateProject* = Call_MigrateProjectsPutMigrateProject_593992(
    name: "migrateProjectsPutMigrateProject", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsPutMigrateProject_593993, base: "",
    url: url_MigrateProjectsPutMigrateProject_593994, schemes: {Scheme.Https})
type
  Call_MigrateProjectsGetMigrateProject_593889 = ref object of OpenApiRestCall_593438
proc url_MigrateProjectsGetMigrateProject_593891(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsGetMigrateProject_593890(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593969 = path.getOrDefault("resourceGroupName")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "resourceGroupName", valid_593969
  var valid_593970 = path.getOrDefault("subscriptionId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "subscriptionId", valid_593970
  var valid_593971 = path.getOrDefault("migrateProjectName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "migrateProjectName", valid_593971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_MigrateProjectsGetMigrateProject_593889;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_MigrateProjectsGetMigrateProject_593889;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsGetMigrateProject
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_593988 = newJObject()
  var query_593990 = newJObject()
  add(path_593988, "resourceGroupName", newJString(resourceGroupName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593988, "subscriptionId", newJString(subscriptionId))
  add(path_593988, "migrateProjectName", newJString(migrateProjectName))
  result = call_593987.call(path_593988, query_593990, nil, nil, nil)

var migrateProjectsGetMigrateProject* = Call_MigrateProjectsGetMigrateProject_593889(
    name: "migrateProjectsGetMigrateProject", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsGetMigrateProject_593890, base: "",
    url: url_MigrateProjectsGetMigrateProject_593891, schemes: {Scheme.Https})
type
  Call_MigrateProjectsPatchMigrateProject_594018 = ref object of OpenApiRestCall_593438
proc url_MigrateProjectsPatchMigrateProject_594020(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsPatchMigrateProject_594019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a migrate project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594021 = path.getOrDefault("resourceGroupName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "resourceGroupName", valid_594021
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("migrateProjectName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "migrateProjectName", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594024 != nil:
    section.add "api-version", valid_594024
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594025 = header.getOrDefault("Accept-Language")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "Accept-Language", valid_594025
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_MigrateProjectsPatchMigrateProject_594018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a migrate project with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_MigrateProjectsPatchMigrateProject_594018;
          resourceGroupName: string; subscriptionId: string; body: JsonNode;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsPatchMigrateProject
  ## Update a migrate project with specified name. Supports partial updates, for example only tags can be provided.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   body: JObject (required)
  ##       : Body with migrate project details.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  var body_594031 = newJObject()
  add(path_594029, "resourceGroupName", newJString(resourceGroupName))
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_594031 = body
  add(path_594029, "migrateProjectName", newJString(migrateProjectName))
  result = call_594028.call(path_594029, query_594030, nil, nil, body_594031)

var migrateProjectsPatchMigrateProject* = Call_MigrateProjectsPatchMigrateProject_594018(
    name: "migrateProjectsPatchMigrateProject", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsPatchMigrateProject_594019, base: "",
    url: url_MigrateProjectsPatchMigrateProject_594020, schemes: {Scheme.Https})
type
  Call_MigrateProjectsDeleteMigrateProject_594006 = ref object of OpenApiRestCall_593438
proc url_MigrateProjectsDeleteMigrateProject_594008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsDeleteMigrateProject_594007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the migrate project. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594009 = path.getOrDefault("resourceGroupName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "resourceGroupName", valid_594009
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  var valid_594011 = path.getOrDefault("migrateProjectName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "migrateProjectName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594013 = header.getOrDefault("Accept-Language")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "Accept-Language", valid_594013
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594014: Call_MigrateProjectsDeleteMigrateProject_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the migrate project. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_MigrateProjectsDeleteMigrateProject_594006;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsDeleteMigrateProject
  ## Delete the migrate project. Deleting non-existent project is a no-operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  add(path_594016, "resourceGroupName", newJString(resourceGroupName))
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  add(path_594016, "migrateProjectName", newJString(migrateProjectName))
  result = call_594015.call(path_594016, query_594017, nil, nil, nil)

var migrateProjectsDeleteMigrateProject* = Call_MigrateProjectsDeleteMigrateProject_594006(
    name: "migrateProjectsDeleteMigrateProject", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}",
    validator: validate_MigrateProjectsDeleteMigrateProject_594007, base: "",
    url: url_MigrateProjectsDeleteMigrateProject_594008, schemes: {Scheme.Https})
type
  Call_DatabaseInstancesEnumerateDatabaseInstances_594032 = ref object of OpenApiRestCall_593438
proc url_DatabaseInstancesEnumerateDatabaseInstances_594034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databaseInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseInstancesEnumerateDatabaseInstances_594033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594035 = path.getOrDefault("resourceGroupName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "resourceGroupName", valid_594035
  var valid_594036 = path.getOrDefault("subscriptionId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "subscriptionId", valid_594036
  var valid_594037 = path.getOrDefault("migrateProjectName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "migrateProjectName", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594038 = query.getOrDefault("api-version")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594038 != nil:
    section.add "api-version", valid_594038
  var valid_594039 = query.getOrDefault("continuationToken")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "continuationToken", valid_594039
  var valid_594040 = query.getOrDefault("pageSize")
  valid_594040 = validateParameter(valid_594040, JInt, required = false, default = nil)
  if valid_594040 != nil:
    section.add "pageSize", valid_594040
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594041 = header.getOrDefault("Accept-Language")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "Accept-Language", valid_594041
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594042: Call_DatabaseInstancesEnumerateDatabaseInstances_594032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_DatabaseInstancesEnumerateDatabaseInstances_594032;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview";
          continuationToken: string = ""; pageSize: int = 0): Recallable =
  ## databaseInstancesEnumerateDatabaseInstances
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  add(path_594044, "resourceGroupName", newJString(resourceGroupName))
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "subscriptionId", newJString(subscriptionId))
  add(query_594045, "continuationToken", newJString(continuationToken))
  add(query_594045, "pageSize", newJInt(pageSize))
  add(path_594044, "migrateProjectName", newJString(migrateProjectName))
  result = call_594043.call(path_594044, query_594045, nil, nil, nil)

var databaseInstancesEnumerateDatabaseInstances* = Call_DatabaseInstancesEnumerateDatabaseInstances_594032(
    name: "databaseInstancesEnumerateDatabaseInstances", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databaseInstances",
    validator: validate_DatabaseInstancesEnumerateDatabaseInstances_594033,
    base: "", url: url_DatabaseInstancesEnumerateDatabaseInstances_594034,
    schemes: {Scheme.Https})
type
  Call_DatabaseInstancesGetDatabaseInstance_594046 = ref object of OpenApiRestCall_593438
proc url_DatabaseInstancesGetDatabaseInstance_594048(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "databaseInstanceName" in path,
        "`databaseInstanceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databaseInstances/"),
               (kind: VariableSegment, value: "databaseInstanceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabaseInstancesGetDatabaseInstance_594047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   databaseInstanceName: JString (required)
  ##                       : Unique name of a database instance in Azure migration hub.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594049 = path.getOrDefault("resourceGroupName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "resourceGroupName", valid_594049
  var valid_594050 = path.getOrDefault("subscriptionId")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "subscriptionId", valid_594050
  var valid_594051 = path.getOrDefault("migrateProjectName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "migrateProjectName", valid_594051
  var valid_594052 = path.getOrDefault("databaseInstanceName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "databaseInstanceName", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594053 != nil:
    section.add "api-version", valid_594053
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594054 = header.getOrDefault("Accept-Language")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "Accept-Language", valid_594054
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_DatabaseInstancesGetDatabaseInstance_594046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_DatabaseInstancesGetDatabaseInstance_594046;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; databaseInstanceName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## databaseInstancesGetDatabaseInstance
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   databaseInstanceName: string (required)
  ##                       : Unique name of a database instance in Azure migration hub.
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  add(path_594057, "migrateProjectName", newJString(migrateProjectName))
  add(path_594057, "databaseInstanceName", newJString(databaseInstanceName))
  result = call_594056.call(path_594057, query_594058, nil, nil, nil)

var databaseInstancesGetDatabaseInstance* = Call_DatabaseInstancesGetDatabaseInstance_594046(
    name: "databaseInstancesGetDatabaseInstance", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databaseInstances/{databaseInstanceName}",
    validator: validate_DatabaseInstancesGetDatabaseInstance_594047, base: "",
    url: url_DatabaseInstancesGetDatabaseInstance_594048, schemes: {Scheme.Https})
type
  Call_DatabasesEnumerateDatabases_594059 = ref object of OpenApiRestCall_593438
proc url_DatabasesEnumerateDatabases_594061(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesEnumerateDatabases_594060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594062 = path.getOrDefault("resourceGroupName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "resourceGroupName", valid_594062
  var valid_594063 = path.getOrDefault("subscriptionId")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "subscriptionId", valid_594063
  var valid_594064 = path.getOrDefault("migrateProjectName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "migrateProjectName", valid_594064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594065 = query.getOrDefault("api-version")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594065 != nil:
    section.add "api-version", valid_594065
  var valid_594066 = query.getOrDefault("continuationToken")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "continuationToken", valid_594066
  var valid_594067 = query.getOrDefault("pageSize")
  valid_594067 = validateParameter(valid_594067, JInt, required = false, default = nil)
  if valid_594067 != nil:
    section.add "pageSize", valid_594067
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594068 = header.getOrDefault("Accept-Language")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "Accept-Language", valid_594068
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_DatabasesEnumerateDatabases_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_DatabasesEnumerateDatabases_594059;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview";
          continuationToken: string = ""; pageSize: int = 0): Recallable =
  ## databasesEnumerateDatabases
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(path_594071, "resourceGroupName", newJString(resourceGroupName))
  add(query_594072, "api-version", newJString(apiVersion))
  add(path_594071, "subscriptionId", newJString(subscriptionId))
  add(query_594072, "continuationToken", newJString(continuationToken))
  add(query_594072, "pageSize", newJInt(pageSize))
  add(path_594071, "migrateProjectName", newJString(migrateProjectName))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var databasesEnumerateDatabases* = Call_DatabasesEnumerateDatabases_594059(
    name: "databasesEnumerateDatabases", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databases",
    validator: validate_DatabasesEnumerateDatabases_594060, base: "",
    url: url_DatabasesEnumerateDatabases_594061, schemes: {Scheme.Https})
type
  Call_DatabasesGetDatabase_594073 = ref object of OpenApiRestCall_593438
proc url_DatabasesGetDatabase_594075(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesGetDatabase_594074(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   databaseName: JString (required)
  ##               : Unique name of a database in Azure migration hub.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594076 = path.getOrDefault("resourceGroupName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "resourceGroupName", valid_594076
  var valid_594077 = path.getOrDefault("subscriptionId")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "subscriptionId", valid_594077
  var valid_594078 = path.getOrDefault("databaseName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "databaseName", valid_594078
  var valid_594079 = path.getOrDefault("migrateProjectName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "migrateProjectName", valid_594079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594080 = query.getOrDefault("api-version")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594080 != nil:
    section.add "api-version", valid_594080
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594081 = header.getOrDefault("Accept-Language")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "Accept-Language", valid_594081
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_DatabasesGetDatabase_594073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_DatabasesGetDatabase_594073;
          resourceGroupName: string; subscriptionId: string; databaseName: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## databasesGetDatabase
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   databaseName: string (required)
  ##               : Unique name of a database in Azure migration hub.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594084 = newJObject()
  var query_594085 = newJObject()
  add(path_594084, "resourceGroupName", newJString(resourceGroupName))
  add(query_594085, "api-version", newJString(apiVersion))
  add(path_594084, "subscriptionId", newJString(subscriptionId))
  add(path_594084, "databaseName", newJString(databaseName))
  add(path_594084, "migrateProjectName", newJString(migrateProjectName))
  result = call_594083.call(path_594084, query_594085, nil, nil, nil)

var databasesGetDatabase* = Call_DatabasesGetDatabase_594073(
    name: "databasesGetDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/databases/{databaseName}",
    validator: validate_DatabasesGetDatabase_594074, base: "",
    url: url_DatabasesGetDatabase_594075, schemes: {Scheme.Https})
type
  Call_MachinesEnumerateMachines_594086 = ref object of OpenApiRestCall_593438
proc url_MachinesEnumerateMachines_594088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/machines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesEnumerateMachines_594087(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594089 = path.getOrDefault("resourceGroupName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "resourceGroupName", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  var valid_594091 = path.getOrDefault("migrateProjectName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "migrateProjectName", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594092 != nil:
    section.add "api-version", valid_594092
  var valid_594093 = query.getOrDefault("continuationToken")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "continuationToken", valid_594093
  var valid_594094 = query.getOrDefault("pageSize")
  valid_594094 = validateParameter(valid_594094, JInt, required = false, default = nil)
  if valid_594094 != nil:
    section.add "pageSize", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_MachinesEnumerateMachines_594086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_MachinesEnumerateMachines_594086;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview";
          continuationToken: string = ""; pageSize: int = 0): Recallable =
  ## machinesEnumerateMachines
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(path_594097, "resourceGroupName", newJString(resourceGroupName))
  add(query_594098, "api-version", newJString(apiVersion))
  add(path_594097, "subscriptionId", newJString(subscriptionId))
  add(query_594098, "continuationToken", newJString(continuationToken))
  add(query_594098, "pageSize", newJInt(pageSize))
  add(path_594097, "migrateProjectName", newJString(migrateProjectName))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var machinesEnumerateMachines* = Call_MachinesEnumerateMachines_594086(
    name: "machinesEnumerateMachines", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/machines",
    validator: validate_MachinesEnumerateMachines_594087, base: "",
    url: url_MachinesEnumerateMachines_594088, schemes: {Scheme.Https})
type
  Call_MachinesGetMachine_594099 = ref object of OpenApiRestCall_593438
proc url_MachinesGetMachine_594101(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "machineName" in path, "`machineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/machines/"),
               (kind: VariableSegment, value: "machineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MachinesGetMachine_594100(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   machineName: JString (required)
  ##              : Unique name of a machine in Azure migration hub.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594102 = path.getOrDefault("resourceGroupName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "resourceGroupName", valid_594102
  var valid_594103 = path.getOrDefault("machineName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "machineName", valid_594103
  var valid_594104 = path.getOrDefault("subscriptionId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "subscriptionId", valid_594104
  var valid_594105 = path.getOrDefault("migrateProjectName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "migrateProjectName", valid_594105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594106 = query.getOrDefault("api-version")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594106 != nil:
    section.add "api-version", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_MachinesGetMachine_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_MachinesGetMachine_594099; resourceGroupName: string;
          machineName: string; subscriptionId: string; migrateProjectName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## machinesGetMachine
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   machineName: string (required)
  ##              : Unique name of a machine in Azure migration hub.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "machineName", newJString(machineName))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(path_594109, "migrateProjectName", newJString(migrateProjectName))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var machinesGetMachine* = Call_MachinesGetMachine_594099(
    name: "machinesGetMachine", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/machines/{machineName}",
    validator: validate_MachinesGetMachine_594100, base: "",
    url: url_MachinesGetMachine_594101, schemes: {Scheme.Https})
type
  Call_EventsEnumerateEvents_594111 = ref object of OpenApiRestCall_593438
proc url_EventsEnumerateEvents_594113(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/migrateEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsEnumerateEvents_594112(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("migrateProjectName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "migrateProjectName", valid_594116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   pageSize: JInt
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594117 = query.getOrDefault("api-version")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594117 != nil:
    section.add "api-version", valid_594117
  var valid_594118 = query.getOrDefault("continuationToken")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "continuationToken", valid_594118
  var valid_594119 = query.getOrDefault("pageSize")
  valid_594119 = validateParameter(valid_594119, JInt, required = false, default = nil)
  if valid_594119 != nil:
    section.add "pageSize", valid_594119
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594120 = header.getOrDefault("Accept-Language")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "Accept-Language", valid_594120
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594121: Call_EventsEnumerateEvents_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_EventsEnumerateEvents_594111;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview";
          continuationToken: string = ""; pageSize: int = 0): Recallable =
  ## eventsEnumerateEvents
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   pageSize: int
  ##           : The number of items to be returned in a single page. This value is honored only if it is less than the 100.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  add(path_594123, "resourceGroupName", newJString(resourceGroupName))
  add(query_594124, "api-version", newJString(apiVersion))
  add(path_594123, "subscriptionId", newJString(subscriptionId))
  add(query_594124, "continuationToken", newJString(continuationToken))
  add(query_594124, "pageSize", newJInt(pageSize))
  add(path_594123, "migrateProjectName", newJString(migrateProjectName))
  result = call_594122.call(path_594123, query_594124, nil, nil, nil)

var eventsEnumerateEvents* = Call_EventsEnumerateEvents_594111(
    name: "eventsEnumerateEvents", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/migrateEvents",
    validator: validate_EventsEnumerateEvents_594112, base: "",
    url: url_EventsEnumerateEvents_594113, schemes: {Scheme.Https})
type
  Call_EventsGetEvent_594125 = ref object of OpenApiRestCall_593438
proc url_EventsGetEvent_594127(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "eventName" in path, "`eventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/migrateEvents/"),
               (kind: VariableSegment, value: "eventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsGetEvent_594126(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   eventName: JString (required)
  ##            : Unique name of an event within a migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("subscriptionId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "subscriptionId", valid_594129
  var valid_594130 = path.getOrDefault("migrateProjectName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "migrateProjectName", valid_594130
  var valid_594131 = path.getOrDefault("eventName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "eventName", valid_594131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594132 = query.getOrDefault("api-version")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594132 != nil:
    section.add "api-version", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_EventsGetEvent_594125; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_EventsGetEvent_594125; resourceGroupName: string;
          subscriptionId: string; migrateProjectName: string; eventName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## eventsGetEvent
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   eventName: string (required)
  ##            : Unique name of an event within a migrate project.
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  add(path_594135, "migrateProjectName", newJString(migrateProjectName))
  add(path_594135, "eventName", newJString(eventName))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var eventsGetEvent* = Call_EventsGetEvent_594125(name: "eventsGetEvent",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/migrateEvents/{eventName}",
    validator: validate_EventsGetEvent_594126, base: "", url: url_EventsGetEvent_594127,
    schemes: {Scheme.Https})
type
  Call_EventsDeleteEvent_594137 = ref object of OpenApiRestCall_593438
proc url_EventsDeleteEvent_594139(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "eventName" in path, "`eventName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/migrateEvents/"),
               (kind: VariableSegment, value: "eventName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsDeleteEvent_594138(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete the migrate event. Deleting non-existent migrate event is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  ##   eventName: JString (required)
  ##            : Unique name of an event within a migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594140 = path.getOrDefault("resourceGroupName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "resourceGroupName", valid_594140
  var valid_594141 = path.getOrDefault("subscriptionId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "subscriptionId", valid_594141
  var valid_594142 = path.getOrDefault("migrateProjectName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "migrateProjectName", valid_594142
  var valid_594143 = path.getOrDefault("eventName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "eventName", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594145: Call_EventsDeleteEvent_594137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the migrate event. Deleting non-existent migrate event is a no-operation.
  ## 
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_EventsDeleteEvent_594137; resourceGroupName: string;
          subscriptionId: string; migrateProjectName: string; eventName: string;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## eventsDeleteEvent
  ## Delete the migrate event. Deleting non-existent migrate event is a no-operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   eventName: string (required)
  ##            : Unique name of an event within a migrate project.
  var path_594147 = newJObject()
  var query_594148 = newJObject()
  add(path_594147, "resourceGroupName", newJString(resourceGroupName))
  add(query_594148, "api-version", newJString(apiVersion))
  add(path_594147, "subscriptionId", newJString(subscriptionId))
  add(path_594147, "migrateProjectName", newJString(migrateProjectName))
  add(path_594147, "eventName", newJString(eventName))
  result = call_594146.call(path_594147, query_594148, nil, nil, nil)

var eventsDeleteEvent* = Call_EventsDeleteEvent_594137(name: "eventsDeleteEvent",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/migrateEvents/{eventName}",
    validator: validate_EventsDeleteEvent_594138, base: "",
    url: url_EventsDeleteEvent_594139, schemes: {Scheme.Https})
type
  Call_MigrateProjectsRefreshMigrateProjectSummary_594149 = ref object of OpenApiRestCall_593438
proc url_MigrateProjectsRefreshMigrateProjectSummary_594151(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/refreshSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsRefreshMigrateProjectSummary_594150(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594152 = path.getOrDefault("resourceGroupName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "resourceGroupName", valid_594152
  var valid_594153 = path.getOrDefault("subscriptionId")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "subscriptionId", valid_594153
  var valid_594154 = path.getOrDefault("migrateProjectName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "migrateProjectName", valid_594154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594155 = query.getOrDefault("api-version")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594155 != nil:
    section.add "api-version", valid_594155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : The goal input which needs to be refreshed.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594157: Call_MigrateProjectsRefreshMigrateProjectSummary_594149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594157.validator(path, query, header, formData, body)
  let scheme = call_594157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594157.url(scheme.get, call_594157.host, call_594157.base,
                         call_594157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594157, url, valid)

proc call*(call_594158: Call_MigrateProjectsRefreshMigrateProjectSummary_594149;
          resourceGroupName: string; subscriptionId: string; input: JsonNode;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsRefreshMigrateProjectSummary
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   input: JObject (required)
  ##        : The goal input which needs to be refreshed.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594159 = newJObject()
  var query_594160 = newJObject()
  var body_594161 = newJObject()
  add(path_594159, "resourceGroupName", newJString(resourceGroupName))
  add(query_594160, "api-version", newJString(apiVersion))
  add(path_594159, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594161 = input
  add(path_594159, "migrateProjectName", newJString(migrateProjectName))
  result = call_594158.call(path_594159, query_594160, nil, nil, body_594161)

var migrateProjectsRefreshMigrateProjectSummary* = Call_MigrateProjectsRefreshMigrateProjectSummary_594149(
    name: "migrateProjectsRefreshMigrateProjectSummary",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/refreshSummary",
    validator: validate_MigrateProjectsRefreshMigrateProjectSummary_594150,
    base: "", url: url_MigrateProjectsRefreshMigrateProjectSummary_594151,
    schemes: {Scheme.Https})
type
  Call_MigrateProjectsRegisterTool_594162 = ref object of OpenApiRestCall_593438
proc url_MigrateProjectsRegisterTool_594164(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/registerTool")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrateProjectsRegisterTool_594163(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594165 = path.getOrDefault("resourceGroupName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "resourceGroupName", valid_594165
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  var valid_594167 = path.getOrDefault("migrateProjectName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "migrateProjectName", valid_594167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594168 = query.getOrDefault("api-version")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594168 != nil:
    section.add "api-version", valid_594168
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594169 = header.getOrDefault("Accept-Language")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "Accept-Language", valid_594169
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : Input containing the name of the tool to be registered.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_MigrateProjectsRegisterTool_594162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_MigrateProjectsRegisterTool_594162;
          resourceGroupName: string; subscriptionId: string; input: JsonNode;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## migrateProjectsRegisterTool
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   input: JObject (required)
  ##        : Input containing the name of the tool to be registered.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  var body_594175 = newJObject()
  add(path_594173, "resourceGroupName", newJString(resourceGroupName))
  add(query_594174, "api-version", newJString(apiVersion))
  add(path_594173, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594175 = input
  add(path_594173, "migrateProjectName", newJString(migrateProjectName))
  result = call_594172.call(path_594173, query_594174, nil, nil, body_594175)

var migrateProjectsRegisterTool* = Call_MigrateProjectsRegisterTool_594162(
    name: "migrateProjectsRegisterTool", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/registerTool",
    validator: validate_MigrateProjectsRegisterTool_594163, base: "",
    url: url_MigrateProjectsRegisterTool_594164, schemes: {Scheme.Https})
type
  Call_SolutionsEnumerateSolutions_594176 = ref object of OpenApiRestCall_593438
proc url_SolutionsEnumerateSolutions_594178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsEnumerateSolutions_594177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594179 = path.getOrDefault("resourceGroupName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "resourceGroupName", valid_594179
  var valid_594180 = path.getOrDefault("subscriptionId")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "subscriptionId", valid_594180
  var valid_594181 = path.getOrDefault("migrateProjectName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "migrateProjectName", valid_594181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594182 = query.getOrDefault("api-version")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594182 != nil:
    section.add "api-version", valid_594182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594183: Call_SolutionsEnumerateSolutions_594176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594183.validator(path, query, header, formData, body)
  let scheme = call_594183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594183.url(scheme.get, call_594183.host, call_594183.base,
                         call_594183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594183, url, valid)

proc call*(call_594184: Call_SolutionsEnumerateSolutions_594176;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsEnumerateSolutions
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594185 = newJObject()
  var query_594186 = newJObject()
  add(path_594185, "resourceGroupName", newJString(resourceGroupName))
  add(query_594186, "api-version", newJString(apiVersion))
  add(path_594185, "subscriptionId", newJString(subscriptionId))
  add(path_594185, "migrateProjectName", newJString(migrateProjectName))
  result = call_594184.call(path_594185, query_594186, nil, nil, nil)

var solutionsEnumerateSolutions* = Call_SolutionsEnumerateSolutions_594176(
    name: "solutionsEnumerateSolutions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions",
    validator: validate_SolutionsEnumerateSolutions_594177, base: "",
    url: url_SolutionsEnumerateSolutions_594178, schemes: {Scheme.Https})
type
  Call_SolutionsPutSolution_594199 = ref object of OpenApiRestCall_593438
proc url_SolutionsPutSolution_594201(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsPutSolution_594200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_594202 = path.getOrDefault("solutionName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "solutionName", valid_594202
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("subscriptionId")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "subscriptionId", valid_594204
  var valid_594205 = path.getOrDefault("migrateProjectName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "migrateProjectName", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594206 = query.getOrDefault("api-version")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594206 != nil:
    section.add "api-version", valid_594206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594208: Call_SolutionsPutSolution_594199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_SolutionsPutSolution_594199; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; solutionInput: JsonNode;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsPutSolution
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  var path_594210 = newJObject()
  var query_594211 = newJObject()
  var body_594212 = newJObject()
  add(path_594210, "solutionName", newJString(solutionName))
  add(path_594210, "resourceGroupName", newJString(resourceGroupName))
  add(query_594211, "api-version", newJString(apiVersion))
  add(path_594210, "subscriptionId", newJString(subscriptionId))
  add(path_594210, "migrateProjectName", newJString(migrateProjectName))
  if solutionInput != nil:
    body_594212 = solutionInput
  result = call_594209.call(path_594210, query_594211, nil, nil, body_594212)

var solutionsPutSolution* = Call_SolutionsPutSolution_594199(
    name: "solutionsPutSolution", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsPutSolution_594200, base: "",
    url: url_SolutionsPutSolution_594201, schemes: {Scheme.Https})
type
  Call_SolutionsGetSolution_594187 = ref object of OpenApiRestCall_593438
proc url_SolutionsGetSolution_594189(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsGetSolution_594188(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_594190 = path.getOrDefault("solutionName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "solutionName", valid_594190
  var valid_594191 = path.getOrDefault("resourceGroupName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "resourceGroupName", valid_594191
  var valid_594192 = path.getOrDefault("subscriptionId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "subscriptionId", valid_594192
  var valid_594193 = path.getOrDefault("migrateProjectName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "migrateProjectName", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594194 != nil:
    section.add "api-version", valid_594194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594195: Call_SolutionsGetSolution_594187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_SolutionsGetSolution_594187; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsGetSolution
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  add(path_594197, "solutionName", newJString(solutionName))
  add(path_594197, "resourceGroupName", newJString(resourceGroupName))
  add(query_594198, "api-version", newJString(apiVersion))
  add(path_594197, "subscriptionId", newJString(subscriptionId))
  add(path_594197, "migrateProjectName", newJString(migrateProjectName))
  result = call_594196.call(path_594197, query_594198, nil, nil, nil)

var solutionsGetSolution* = Call_SolutionsGetSolution_594187(
    name: "solutionsGetSolution", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsGetSolution_594188, base: "",
    url: url_SolutionsGetSolution_594189, schemes: {Scheme.Https})
type
  Call_SolutionsPatchSolution_594226 = ref object of OpenApiRestCall_593438
proc url_SolutionsPatchSolution_594228(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsPatchSolution_594227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a solution with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_594229 = path.getOrDefault("solutionName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "solutionName", valid_594229
  var valid_594230 = path.getOrDefault("resourceGroupName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "resourceGroupName", valid_594230
  var valid_594231 = path.getOrDefault("subscriptionId")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "subscriptionId", valid_594231
  var valid_594232 = path.getOrDefault("migrateProjectName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "migrateProjectName", valid_594232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594233 = query.getOrDefault("api-version")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594233 != nil:
    section.add "api-version", valid_594233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594235: Call_SolutionsPatchSolution_594226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a solution with specified name. Supports partial updates, for example only tags can be provided.
  ## 
  let valid = call_594235.validator(path, query, header, formData, body)
  let scheme = call_594235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594235.url(scheme.get, call_594235.host, call_594235.base,
                         call_594235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594235, url, valid)

proc call*(call_594236: Call_SolutionsPatchSolution_594226; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; solutionInput: JsonNode;
          apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsPatchSolution
  ## Update a solution with specified name. Supports partial updates, for example only tags can be provided.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  ##   solutionInput: JObject (required)
  ##                : The input for the solution.
  var path_594237 = newJObject()
  var query_594238 = newJObject()
  var body_594239 = newJObject()
  add(path_594237, "solutionName", newJString(solutionName))
  add(path_594237, "resourceGroupName", newJString(resourceGroupName))
  add(query_594238, "api-version", newJString(apiVersion))
  add(path_594237, "subscriptionId", newJString(subscriptionId))
  add(path_594237, "migrateProjectName", newJString(migrateProjectName))
  if solutionInput != nil:
    body_594239 = solutionInput
  result = call_594236.call(path_594237, query_594238, nil, nil, body_594239)

var solutionsPatchSolution* = Call_SolutionsPatchSolution_594226(
    name: "solutionsPatchSolution", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsPatchSolution_594227, base: "",
    url: url_SolutionsPatchSolution_594228, schemes: {Scheme.Https})
type
  Call_SolutionsDeleteSolution_594213 = ref object of OpenApiRestCall_593438
proc url_SolutionsDeleteSolution_594215(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsDeleteSolution_594214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the solution. Deleting non-existent project is a no-operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_594216 = path.getOrDefault("solutionName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "solutionName", valid_594216
  var valid_594217 = path.getOrDefault("resourceGroupName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "resourceGroupName", valid_594217
  var valid_594218 = path.getOrDefault("subscriptionId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "subscriptionId", valid_594218
  var valid_594219 = path.getOrDefault("migrateProjectName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "migrateProjectName", valid_594219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594220 = query.getOrDefault("api-version")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594220 != nil:
    section.add "api-version", valid_594220
  result.add "query", section
  ## parameters in `header` object:
  ##   Accept-Language: JString
  ##                  : Standard request header. Used by service to respond to client in appropriate language.
  section = newJObject()
  var valid_594221 = header.getOrDefault("Accept-Language")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "Accept-Language", valid_594221
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594222: Call_SolutionsDeleteSolution_594213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the solution. Deleting non-existent project is a no-operation.
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_SolutionsDeleteSolution_594213; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsDeleteSolution
  ## Delete the solution. Deleting non-existent project is a no-operation.
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(path_594224, "solutionName", newJString(solutionName))
  add(path_594224, "resourceGroupName", newJString(resourceGroupName))
  add(query_594225, "api-version", newJString(apiVersion))
  add(path_594224, "subscriptionId", newJString(subscriptionId))
  add(path_594224, "migrateProjectName", newJString(migrateProjectName))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var solutionsDeleteSolution* = Call_SolutionsDeleteSolution_594213(
    name: "solutionsDeleteSolution", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}",
    validator: validate_SolutionsDeleteSolution_594214, base: "",
    url: url_SolutionsDeleteSolution_594215, schemes: {Scheme.Https})
type
  Call_SolutionsCleanupSolutionData_594240 = ref object of OpenApiRestCall_593438
proc url_SolutionsCleanupSolutionData_594242(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/cleanupData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsCleanupSolutionData_594241(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_594243 = path.getOrDefault("solutionName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "solutionName", valid_594243
  var valid_594244 = path.getOrDefault("resourceGroupName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "resourceGroupName", valid_594244
  var valid_594245 = path.getOrDefault("subscriptionId")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "subscriptionId", valid_594245
  var valid_594246 = path.getOrDefault("migrateProjectName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "migrateProjectName", valid_594246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594247 = query.getOrDefault("api-version")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594247 != nil:
    section.add "api-version", valid_594247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594248: Call_SolutionsCleanupSolutionData_594240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594248.validator(path, query, header, formData, body)
  let scheme = call_594248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594248.url(scheme.get, call_594248.host, call_594248.base,
                         call_594248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594248, url, valid)

proc call*(call_594249: Call_SolutionsCleanupSolutionData_594240;
          solutionName: string; resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsCleanupSolutionData
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594250 = newJObject()
  var query_594251 = newJObject()
  add(path_594250, "solutionName", newJString(solutionName))
  add(path_594250, "resourceGroupName", newJString(resourceGroupName))
  add(query_594251, "api-version", newJString(apiVersion))
  add(path_594250, "subscriptionId", newJString(subscriptionId))
  add(path_594250, "migrateProjectName", newJString(migrateProjectName))
  result = call_594249.call(path_594250, query_594251, nil, nil, nil)

var solutionsCleanupSolutionData* = Call_SolutionsCleanupSolutionData_594240(
    name: "solutionsCleanupSolutionData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}/cleanupData",
    validator: validate_SolutionsCleanupSolutionData_594241, base: "",
    url: url_SolutionsCleanupSolutionData_594242, schemes: {Scheme.Https})
type
  Call_SolutionsGetConfig_594252 = ref object of OpenApiRestCall_593438
proc url_SolutionsGetConfig_594254(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "migrateProjectName" in path,
        "`migrateProjectName` is a required path parameter"
  assert "solutionName" in path, "`solutionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Migrate/migrateProjects/"),
               (kind: VariableSegment, value: "migrateProjectName"),
               (kind: ConstantSegment, value: "/solutions/"),
               (kind: VariableSegment, value: "solutionName"),
               (kind: ConstantSegment, value: "/getConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SolutionsGetConfig_594253(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   solutionName: JString (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: JString (required)
  ##                     : Name of the Azure Migrate project.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `solutionName` field"
  var valid_594255 = path.getOrDefault("solutionName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "solutionName", valid_594255
  var valid_594256 = path.getOrDefault("resourceGroupName")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "resourceGroupName", valid_594256
  var valid_594257 = path.getOrDefault("subscriptionId")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "subscriptionId", valid_594257
  var valid_594258 = path.getOrDefault("migrateProjectName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "migrateProjectName", valid_594258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Standard request header. Used by service to identify API version used by client.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594259 = query.getOrDefault("api-version")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = newJString("2018-09-01-preview"))
  if valid_594259 != nil:
    section.add "api-version", valid_594259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594260: Call_SolutionsGetConfig_594252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594260.validator(path, query, header, formData, body)
  let scheme = call_594260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594260.url(scheme.get, call_594260.host, call_594260.base,
                         call_594260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594260, url, valid)

proc call*(call_594261: Call_SolutionsGetConfig_594252; solutionName: string;
          resourceGroupName: string; subscriptionId: string;
          migrateProjectName: string; apiVersion: string = "2018-09-01-preview"): Recallable =
  ## solutionsGetConfig
  ##   solutionName: string (required)
  ##               : Unique name of a migration solution within a migrate project.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Azure Resource Group that migrate project is part of.
  ##   apiVersion: string (required)
  ##             : Standard request header. Used by service to identify API version used by client.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription Id in which migrate project was created.
  ##   migrateProjectName: string (required)
  ##                     : Name of the Azure Migrate project.
  var path_594262 = newJObject()
  var query_594263 = newJObject()
  add(path_594262, "solutionName", newJString(solutionName))
  add(path_594262, "resourceGroupName", newJString(resourceGroupName))
  add(query_594263, "api-version", newJString(apiVersion))
  add(path_594262, "subscriptionId", newJString(subscriptionId))
  add(path_594262, "migrateProjectName", newJString(migrateProjectName))
  result = call_594261.call(path_594262, query_594263, nil, nil, nil)

var solutionsGetConfig* = Call_SolutionsGetConfig_594252(
    name: "solutionsGetConfig", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Migrate/migrateProjects/{migrateProjectName}/solutions/{solutionName}/getConfig",
    validator: validate_SolutionsGetConfig_594253, base: "",
    url: url_SolutionsGetConfig_594254, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
