
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2018-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Storage Management API.
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "storage-managementpolicy"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagementPoliciesCreateOrUpdate_593974 = ref object of OpenApiRestCall_593424
proc url_ManagementPoliciesCreateOrUpdate_593976(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "managementPolicyName" in path,
        "`managementPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/managementPolicies/"),
               (kind: VariableSegment, value: "managementPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementPoliciesCreateOrUpdate_593975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the data policy rules associated with the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: JString (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593994 = path.getOrDefault("resourceGroupName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "resourceGroupName", valid_593994
  var valid_593995 = path.getOrDefault("subscriptionId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "subscriptionId", valid_593995
  var valid_593996 = path.getOrDefault("managementPolicyName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = newJString("default"))
  if valid_593996 != nil:
    section.add "managementPolicyName", valid_593996
  var valid_593997 = path.getOrDefault("accountName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "accountName", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   properties: JObject (required)
  ##             : The data policy rules to set to a storage account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_ManagementPoliciesCreateOrUpdate_593974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the data policy rules associated with the specified storage account.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_ManagementPoliciesCreateOrUpdate_593974;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          properties: JsonNode; accountName: string;
          managementPolicyName: string = "default"): Recallable =
  ## managementPoliciesCreateOrUpdate
  ## Sets the data policy rules associated with the specified storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: string (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   properties: JObject (required)
  ##             : The data policy rules to set to a storage account.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  var body_594004 = newJObject()
  add(path_594002, "resourceGroupName", newJString(resourceGroupName))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(path_594002, "managementPolicyName", newJString(managementPolicyName))
  if properties != nil:
    body_594004 = properties
  add(path_594002, "accountName", newJString(accountName))
  result = call_594001.call(path_594002, query_594003, nil, nil, body_594004)

var managementPoliciesCreateOrUpdate* = Call_ManagementPoliciesCreateOrUpdate_593974(
    name: "managementPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/managementPolicies/{managementPolicyName}",
    validator: validate_ManagementPoliciesCreateOrUpdate_593975, base: "",
    url: url_ManagementPoliciesCreateOrUpdate_593976, schemes: {Scheme.Https})
type
  Call_ManagementPoliciesGet_593646 = ref object of OpenApiRestCall_593424
proc url_ManagementPoliciesGet_593648(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "managementPolicyName" in path,
        "`managementPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/managementPolicies/"),
               (kind: VariableSegment, value: "managementPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementPoliciesGet_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the data policy rules associated with the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: JString (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593821 = path.getOrDefault("resourceGroupName")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "resourceGroupName", valid_593821
  var valid_593822 = path.getOrDefault("subscriptionId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "subscriptionId", valid_593822
  var valid_593836 = path.getOrDefault("managementPolicyName")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = newJString("default"))
  if valid_593836 != nil:
    section.add "managementPolicyName", valid_593836
  var valid_593837 = path.getOrDefault("accountName")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = nil)
  if valid_593837 != nil:
    section.add "accountName", valid_593837
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593838 = query.getOrDefault("api-version")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = nil)
  if valid_593838 != nil:
    section.add "api-version", valid_593838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593861: Call_ManagementPoliciesGet_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data policy rules associated with the specified storage account.
  ## 
  let valid = call_593861.validator(path, query, header, formData, body)
  let scheme = call_593861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593861.url(scheme.get, call_593861.host, call_593861.base,
                         call_593861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593861, url, valid)

proc call*(call_593932: Call_ManagementPoliciesGet_593646;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; managementPolicyName: string = "default"): Recallable =
  ## managementPoliciesGet
  ## Gets the data policy rules associated with the specified storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: string (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_593933 = newJObject()
  var query_593935 = newJObject()
  add(path_593933, "resourceGroupName", newJString(resourceGroupName))
  add(query_593935, "api-version", newJString(apiVersion))
  add(path_593933, "subscriptionId", newJString(subscriptionId))
  add(path_593933, "managementPolicyName", newJString(managementPolicyName))
  add(path_593933, "accountName", newJString(accountName))
  result = call_593932.call(path_593933, query_593935, nil, nil, nil)

var managementPoliciesGet* = Call_ManagementPoliciesGet_593646(
    name: "managementPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/managementPolicies/{managementPolicyName}",
    validator: validate_ManagementPoliciesGet_593647, base: "",
    url: url_ManagementPoliciesGet_593648, schemes: {Scheme.Https})
type
  Call_ManagementPoliciesDelete_594005 = ref object of OpenApiRestCall_593424
proc url_ManagementPoliciesDelete_594007(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "managementPolicyName" in path,
        "`managementPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/managementPolicies/"),
               (kind: VariableSegment, value: "managementPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementPoliciesDelete_594006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the data policy rules associated with the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: JString (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594008 = path.getOrDefault("resourceGroupName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "resourceGroupName", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  var valid_594010 = path.getOrDefault("managementPolicyName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = newJString("default"))
  if valid_594010 != nil:
    section.add "managementPolicyName", valid_594010
  var valid_594011 = path.getOrDefault("accountName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "accountName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_ManagementPoliciesDelete_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the data policy rules associated with the specified storage account.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_ManagementPoliciesDelete_594005;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; managementPolicyName: string = "default"): Recallable =
  ## managementPoliciesDelete
  ## Deletes the data policy rules associated with the specified storage account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   managementPolicyName: string (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(path_594015, "resourceGroupName", newJString(resourceGroupName))
  add(query_594016, "api-version", newJString(apiVersion))
  add(path_594015, "subscriptionId", newJString(subscriptionId))
  add(path_594015, "managementPolicyName", newJString(managementPolicyName))
  add(path_594015, "accountName", newJString(accountName))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var managementPoliciesDelete* = Call_ManagementPoliciesDelete_594005(
    name: "managementPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/managementPolicies/{managementPolicyName}",
    validator: validate_ManagementPoliciesDelete_594006, base: "",
    url: url_ManagementPoliciesDelete_594007, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
